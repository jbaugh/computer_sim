
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
    cmd_type = OpCode.get_command_type(cmd)

    case cmd_type
    when 'LD'
      call_ld(cmd[2], addr, i_reg, m_spec)
    when 'LDN'
      call_ldn(cmd[2], addr, i_reg, m_spec)
    when 'ST'
      call_st(cmd[2], addr, i_reg, m_spec)
    when 'ADD'
      call_add(nil, addr, i_reg, m_spec)
    when 'SUB'
      call_sub(nil, addr, i_reg, m_spec)
    when 'MUL'
      call_mul(nil, addr, i_reg, m_spec)
    when 'DIV'
      call_div(nil, addr, i_reg, m_spec)
    when 'ENT'
      call_ent(cmd[3], addr, i_reg, m_spec)
    when 'ENN'
      call_enn(cmd[3], addr, i_reg, m_spec)
    when 'INC'
      call_inc(cmd[3], addr, i_reg, m_spec)
    when 'DEC'
      call_inc(cmd[3], addr, i_reg, m_spec)
    end
  rescue
    raise "Invalid operation: \n\t#{operation.inspect} \n\t#{operation.to_s}"
  end

  def call_ld(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    mem_addr = get_mem_addr(addr, i_reg)

    reg.value = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r]).value
  end

  def call_ldn(reg_key, addr, i_reg, m_spec)
    call_ld(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    reg.word.negate_sign
  end

  def call_st(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    mem_addr = get_mem_addr(addr, i_reg)

    @computer.memory.write(mem_addr, reg.value, m_spec[:l], m_spec[:r])
  end

  def call_add(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)

    adder = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r])
    sum = @registers['A'].word.to_i + adder.to_i
    @registers['A'].word.from_int(sum)
  end

  def call_sub(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)

    adder = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r])
    sum = @registers['A'].word.to_i - adder.to_i
    @registers['A'].word.from_int(sum)
  end

  def call_mul(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)

    adder = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r])
    sum = @registers['A'].word.to_i * adder.to_i
    @registers['A'].word.from_int(sum)
  end

  def call_div(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)

    adder = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r])
    num1 = @registers['A'].word.to_i
    num2 = adder.to_i
    @registers['A'].word.from_int(num1 / num2)
    @registers['X'].word.from_int(num1 % num2)
  end

  def call_ent(reg_key, addr, i_reg, m_spec)
    val = get_mem_addr(addr, i_reg)

    @registers[reg_key].word.from_int(val)
  end

  def call_enn(reg_key, addr, i_reg, m_spec)
    val = get_mem_addr(addr, i_reg)

    @registers[reg_key].word.from_int(-val)
  end

  def call_inc(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]

    val = get_mem_addr(addr, i_reg)
    val += reg.word.to_i
    
    reg.word.from_int(val)
  end

  def call_dec(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]

    val = get_mem_addr(addr, i_reg)
    val += reg.word.to_i

    reg.word.from_int(-val)
  end

private

  def get_mem_addr(addr, i_reg)
    mem_addr = addr
    mem_addr += i_reg.word.to_i if i_reg
    mem_addr
  end
end
