
load 'register.rb'

class CPU
  attr_accessor :registers, :pc
  attr_reader :op
  
  def initialize(computer)
    @computer = computer
    self.reset
  end

  def reset
    @registers = {}
    @op = Word.new(5)
    @pc = 0

    @registers['A'] = Register.new(5)
    @registers['X'] = Register.new(5)
    @registers['J'] = Register.new(2)
    @registers['CMP'] = Register.new(1)
    @registers['OV'] = Register.new(1)

    @registers['I1'] = Register.new(2)
    @registers['I2'] = Register.new(2)
    @registers['I3'] = Register.new(2)
    @registers['I4'] = Register.new(2)
    @registers['I5'] = Register.new(2)
    @registers['I6'] = Register.new(2)
  end

  # Loads a program as a string
  def load_program(program, offset = 0)
    @program = program
  end

  # Execute the program that was previously loaded into memory
  def execute_program(start = 0)
    @pc = start
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
      call_dec(cmd[3], addr, i_reg, m_spec)
    when 'CMP'
      call_cmp(cmd[3], addr, i_reg, m_spec)
    when 'JMP'
      call_jmp(nil, addr, i_reg, nil)
    when 'JSJ'
      call_jsj(nil, addr, i_reg, nil)
    when 'JOV'
      call_jov(nil, addr, i_reg, nil)
    when 'JNOV'
      call_jnov(nil, addr, i_reg, nil)
    when 'JL'
      call_jl(nil, addr, i_reg, nil)
    when 'JE'
      call_je(nil, addr, i_reg, nil)
    when 'JG'
      call_jg(nil, addr, i_reg, nil)
    when 'JLE'
      call_jle(nil, addr, i_reg, nil)
    when 'JNE'
      call_jne(nil, addr, i_reg, nil)
    when 'JGE'
      call_jge(nil, addr, i_reg, nil)
    when 'JN'
      call_jn(cmd[1], addr, i_reg, m_spec)
    when 'JZ'
      call_jz(cmd[1], addr, i_reg, m_spec)
    when 'JP'
      call_jp(cmd[1], addr, i_reg, m_spec)
    when 'JNN'
      call_jnn(cmd[1], addr, i_reg, m_spec)
    when 'JNZ'
      call_jnz(cmd[1], addr, i_reg, m_spec)
    when 'JNP'
      call_jnp(cmd[1], addr, i_reg, m_spec)
    when 'MOVE'
      call_move(nil, addr, i_reg, m_spec)
    when 'SLA'
      call_sla(nil, addr, i_reg, m_spec)
    when 'SRA'
      call_sra(nil, addr, i_reg, m_spec)
    when 'SLAX'
      call_slax(nil, addr, i_reg, m_spec)
    when 'SRAX'
      call_srax(nil, addr, i_reg, m_spec)
    when 'SLC'
      call_slc(nil, addr, i_reg, m_spec)
    when 'SRC'
      call_src(nil, addr, i_reg, m_spec)
    end
  rescue
    raise "Invalid operation: \n\t#{operation.inspect} \n\t#{operation.to_str}"
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
    val = get_mem_addr(addr, i_reg) + reg.word.to_i
    reg.word.from_int(val)
  end

  def call_dec(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    val = reg.word.to_i - get_mem_addr(addr, i_reg)
    reg.word.from_int(val)
  end

  def call_cmp(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    mem_addr = get_mem_addr(addr, i_reg)

    reg_value = reg.word.to_i
    mem_value = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r]).to_i

    if reg_value > mem_value
      @registers['CMP'].value = ['+',1]
    elsif reg_value == mem_value
      @registers['CMP'].value = ['+',0]
    else
      @registers['CMP'].value = ['-',1]
    end
  end

  def call_jmp(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    @registers['J'].word.from_int(mem_addr)
    @pc = mem_addr
  end

  def call_jsj(reg_key, addr, i_reg, m_spec)
    @pc = get_mem_addr(addr, i_reg)
  end

  def call_jov(reg_key, addr, i_reg, m_spec)
    if @registers['OV'].value[1] == 1
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jnov(reg_key, addr, i_reg, m_spec)
    if @registers['OV'].value[1] == 0
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jl(reg_key, addr, i_reg, m_spec)
    if @registers['CMP'].negative?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_je(reg_key, addr, i_reg, m_spec)
    if @registers['CMP'].zero?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jg(reg_key, addr, i_reg, m_spec)
    if @registers['CMP'].positive?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jle(reg_key, addr, i_reg, m_spec)
    if !@registers['CMP'].positive?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jne(reg_key, addr, i_reg, m_spec)
    if !@registers['CMP'].zero?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jge(reg_key, addr, i_reg, m_spec)
    if !@registers['CMP'].negative?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jn(reg_key, addr, i_reg, m_spec)
    if @registers[reg_key].negative?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jz(reg_key, addr, i_reg, m_spec)
    if @registers[reg_key].zero?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jp(reg_key, addr, i_reg, m_spec)
    if @registers[reg_key].positive?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jnn(reg_key, addr, i_reg, m_spec)
    if !@registers[reg_key].negative?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jnz(reg_key, addr, i_reg, m_spec)
    if !@registers[reg_key].zero?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_jnp(reg_key, addr, i_reg, m_spec)
    if !@registers[reg_key].positive?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  def call_move(reg_key, addr, i_reg, m_spec)
    puts "#{__method__} unfnished."
    mem_addr = get_mem_addr(addr, i_reg)
    (0..(m_spec - 1)).each do |i|
      @computer.memory.write(mem_addr + i, Word.default(5))
    end
  end

  def call_sla(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    puts "#{__method__} unfnished."
  end

  def call_sra(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    puts "#{__method__} unfnished."
  end

  def call_slax(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    puts "#{__method__} unfnished."
  end

  def call_srax(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    puts "#{__method__} unfnished."
  end

  def call_slc(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    puts "#{__method__} unfnished."
  end

  def call_src(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    puts "#{__method__} unfnished."
  end

private

  def get_mem_addr(addr, i_reg)
    mem_addr = addr
    mem_addr += i_reg.word.to_i if i_reg
    mem_addr
  end
end
