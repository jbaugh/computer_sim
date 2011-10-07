
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

  def overflowed?
    @overflow
  end

  def sign
    @value[0]
  end

  def sign=(v)
    @value[0] = v
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