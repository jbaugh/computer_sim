
load 'op_code.rb'
load 'mod_spec.rb'

class Word
  attr_accessor :value
  attr_reader :size

  def initialize(size)
    @size = size
    self.reset
  end

  # Resets this word to default value
  def reset
    @value = Word.default(@size)
    @overflow = false
  end

  # Generates a word based on an integer value
  # Returns value
  def from_int(int_val)
    if int_val < 0
      self.value[0] = '-'
      int_val = -int_val
    else
      self.value[0] = '+'
    end

    @size.downto(1) { |i|
      self.value[i] = int_val % Word.max_byte
      int_val = (int_val / Word.max_byte).to_i
    }

    @overflow = (int_val != 0)
    self
  end

  # Converts the word value into an integer
  def to_i
    int_val = 0
    1.upto(@size) do |i| 
      int_val = int_val * Word.max_byte + self.value[i]
    end

    if self.value[0] == '-'
      return -int_val
    end
    
    int_val
  end

  def from_string(line)
    chunks = line.split(' ')
    
    comma_index = chunks.last.index(',')
    addr = chunks.last[0..comma_index - 1]
    spec = chunks.last[comma_index + 1..-1]
    
    paren_index = spec.index('(')
    i_spec = spec[0..paren_index - 1]
    m_spec = spec[paren_index..-1]

    mem_locs = parse_memory_address(addr)

    @value[1] = mem_locs.first.to_i
    @value[2] = mem_locs.last.to_i
    @value[3] = parse_index_spec(i_spec)
    @value[4] = parse_mod_spec(m_spec)
    @value[5] = OpCode.get_byte(chunks.first)
  end

  def to_str
    mem = self.addr.to_s
    i = @value[3].to_s
    spc = self.mod_spec
    m_spec = "(#{spc[:l]}:#{spc[:r]})"
    cmd = self.get_command

    return "#{cmd} #{mem},#{i}#{m_spec}"
  end

  # Parses out the memory address into two
  # bytes to be stored in a Word
  # input format is ####
  def parse_memory_address(str)
    while str.size < 4
       str = '0' + str  
    end
    str.scan(/../)
  end

  # Parse out the index register
  # input format is i(#:#)
  def parse_index_spec(str)
    if str && !str.empty?
      return str.to_i
    else
      return 0
    end
  end

  # Parse out the modification spec
  # input format is (#:#)
  def parse_mod_spec(str)
    if str && !str.empty?
      left = str.split(/:/).first.sub('(', '').to_i
      right = str.split(/:/).last.sub(')', '').to_i
      return ModSpec.get_byte({:l => left, :r => right})
    else 
      return 0
    end
  end

  def shift_left(val = 0)
    old_val = @value[1]
    (1.upto(@size - 1)).each do |i|
      @value[i] = @value[i + 1]
    end
    @value[@size] = val
    old_val
  end

  def shift_right(val = 0)
    old_val = @value[@size]
    ((@size - 1).downto(1)).each do |i|
      @value[i + 1] = @value[i]
    end
    @value[1] = val
    old_val
  end

  def rotate_left
    shift_left(@value[1])
  end

  def rotate_right
    shift_right(@value[@size])
  end

  def []i
    @value[i]
  end

  def []=i
    @value[i] = i
  end

  def overflowed?
    @overflow
  end

  def sign
    @value[0]
  end

  def sign=(v)
    @value[0] = v
  end

  def addr
    mem = @value[1].to_s + @value[2].to_s
    mem += '0' if @value[2].to_s.size == 1
    return mem.to_i
  end

  def index_register
    "I#{@value[3]}"
  end

  def mod_spec
    ModSpec.get_command(value[4])
  end

  def get_command
    OpCode.get_command(@value[5])
  end

  def negate_sign
    self.sign = (self.sign == "+" ? "-" : "+")
  end

  def self.default(amt) 
    def_wor = ['+']
    (1..amt).each { def_wor << 0 }
    def_wor
  end

  def self.max_byte
    100 
  end
end