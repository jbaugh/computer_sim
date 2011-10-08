
load 'register.rb'

class CPU
  attr_accessor :registers
  attr_reader :op
  
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
    @op.from_string(line)
  end

  # Executes an operation
  def execute_operation(operation)
    cmd = operation.get_command
    addr = operation.addr
    i_reg = @registers[operation.index_register]
    m_spec = @registers.mod_spec
    
    
  end
end
