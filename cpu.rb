
load 'register.rb'

class CPU
  attr_accessor :registers
  
  def initialize(computer)
    @computer = computer
    self.reset
  end

  def reset
    @registers = {}
    @op = Word.new(5)

    @registers['A'] = Register.new(5)
    @registers['X'] = Register.new(5)
    @registers['J'] = Register.new(2)
    @registers['CMP'] = Register.new(3)

    @registers['I1'] = Register.new(2)
    @registers['I2'] = Register.new(2)
    @registers['I3'] = Register.new(2)
    @registers['I4'] = Register.new(2)
    @registers['I5'] = Register.new(2)
    @registers['I6'] = Register.new(2)
  end

  # Loads a program as a string
  def load_program(p)
    @program = p
  end

  # Execute the program that was previously loaded into memory
  def execute_program 
    @program.each_line do |line| 
      self.parse_line(line) 
    end
  end

  # Parse a single line of MIXAL (a single operation)
  def parse_line(line)
    #LDA ADDR,i(0:5)
    codes = line.split(' ')
    @op.value[1] = 
    
  end

  # Once the line has been parsed into logical segments,
  # this method determines what to do with what memory word
  def parse_code(instruction, memory, fspec)
    left = 0
    right = 5

    if fspec && !fspec.empty?
      left = fspec.split(/:/).first.sub('(', '').to_i
      right = fspec.split(/:/).last.sub(')', '').to_i
    end
  end
end