
load 'register.rb'

class CPU
  attr_accessor :registers, :pc
  attr_reader :op
  attr_accessor :compile_start, :program_start, :symbols
  
  def initialize(computer)
    @computer = computer
    self.reset
  end

  def reset
    @registers = {}
    @op = Word.new(5)
    @pc = 0
    @symbols = []
    @compile_start = 0
    @program_start = 0
    @compile_counter = 0

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
    compile_program(@program)
  end

  # Compiles MIXAL into words
  def compile_program(program)
    @compile_counter = 0
    @program.each_line do |line| 
      self.parse_line(line) 
    end
  end

  # Execute the program that was previously loaded into memory
  def execute_program
    @pc = @program_start
    
  end

  # Parse a single line of MIXAL (a single operation)
  def parse_line(line)
    if !check_for_directive(line)
      
      @compile_counter += 1
    end
  end

  # Checks for MIXAL directives, returns true if there 
  # is a directive
  def check_for_directive(line)
    chunks = line.split(' ')
    if chunks.include? 'ORIG'
      @compile_start = chunks.last.to_i
      @compile_counter = @compile_start
      return true

    elsif chunks.include? 'EQU'
      sym = chunks.first
      val = chunks.last
      if !@symbols.include? sym
        @symbols << {sym => val}
      end
      return true

    elsif chunks.include? 'CON'
      val = chunks.last
      @computer.memory.storage[@pc].from_int(val.to_i)
      @compile_counter += 1
      return true

    elsif chunks.include? 'ALF'
      val = chunks.last
      @computer.memory.storage[@pc].from_string(val.to_s)
      @compile_counter += 1
      return true

    elsif chunks.include? 'END'
      @program_start = chunks.last.to_i
      return true
    end

    return false
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
    when 'NOP'
      call_nop(nil, nil, nil, nil)
    when 'HLT'
      call_hlt(nil, nil, nil, nil)
    when 'IN'
      call_in(nil, addr, i_reg, m_spec)
    when 'OUT'
      call_out(nil, addr, i_reg, m_spec)
    when 'IOC'
      call_ioc(nil, addr, i_reg, m_spec)
    when 'JRED'
      call_jred(nil, addr, i_reg, m_spec)
    when 'JBUS'
      call_jbus(nil, addr, i_reg, m_spec)
    when 'NUM'
      call_num(nil, addr, i_reg, m_spec)
    when 'CHAR'
      call_char(nil, addr, i_reg, m_spec)
    end
  rescue
    raise "Invalid operation: \n\t#{operation.inspect} \n\t#{operation.to_code}"
  end

  # Loads a block of memory into a register
  def call_ld(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    mem_addr = get_mem_addr(addr, i_reg)

    reg.value = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r]).value
  end

  # Loads a block of memory into a register and negates the sign
  def call_ldn(reg_key, addr, i_reg, m_spec)
    call_ld(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    reg.word.negate_sign
  end

  # Stores a register value to memory
  def call_st(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    mem_addr = get_mem_addr(addr, i_reg)

    @computer.memory.write(mem_addr, reg.value, m_spec[:l], m_spec[:r])
  end

  # Adds a value to the A register
  def call_add(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)

    adder = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r])
    sum = @registers['A'].word.to_i + adder.to_i
    @registers['A'].word.from_int(sum)
  end

  # Subtracts a value from the A register
  def call_sub(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)

    adder = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r])
    sum = @registers['A'].word.to_i - adder.to_i
    @registers['A'].word.from_int(sum)
  end

  # Multiplies a value and the A register
  def call_mul(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)

    adder = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r])
    sum = @registers['A'].word.to_i * adder.to_i
    @registers['A'].word.from_int(sum)
  end

  # Divides a value and the A register
  # Stores modulo in X register
  def call_div(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)

    adder = @computer.memory.read(mem_addr, m_spec[:l], m_spec[:r])
    num1 = @registers['A'].word.to_i
    num2 = adder.to_i
    @registers['A'].word.from_int(num1 / num2)
    @registers['X'].word.from_int(num1 % num2)
  end

  # Sets register to the address
  def call_ent(reg_key, addr, i_reg, m_spec)
    val = get_mem_addr(addr, i_reg)
    @registers[reg_key].word.from_int(val)
  end

  # Sets register to opposite of the address
  def call_enn(reg_key, addr, i_reg, m_spec)
    val = get_mem_addr(addr, i_reg)
    @registers[reg_key].word.from_int(-val)
  end

  # Increase a register by some value
  def call_inc(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    val = get_mem_addr(addr, i_reg) + reg.word.to_i
    reg.word.from_int(val)
  end

  # Decrease a register by some value
  def call_dec(reg_key, addr, i_reg, m_spec)
    reg = @registers[reg_key]
    val = reg.word.to_i - get_mem_addr(addr, i_reg)
    reg.word.from_int(val)
  end

  # Compare memory to register and stores result in CMP register
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

  # Jump and set J register to jump address
  def call_jmp(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    @registers['J'].word.from_int(mem_addr)
    @pc = mem_addr
  end

  # Jump without setting any registers
  def call_jsj(reg_key, addr, i_reg, m_spec)
    @pc = get_mem_addr(addr, i_reg)
  end

  # Jump if there was an overflow
  def call_jov(reg_key, addr, i_reg, m_spec)
    if @registers['OV'].value[1] == 1
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if there was no overflow
  def call_jnov(reg_key, addr, i_reg, m_spec)
    if @registers['OV'].value[1] == 0
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if last comparise was less than
  def call_jl(reg_key, addr, i_reg, m_spec)
    if @registers['CMP'].negative?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if last comparise was equal
  def call_je(reg_key, addr, i_reg, m_spec)
    if @registers['CMP'].zero?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if last comparise was greater than
  def call_jg(reg_key, addr, i_reg, m_spec)
    if @registers['CMP'].positive?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if last comparise was lesser or equal
  def call_jle(reg_key, addr, i_reg, m_spec)
    if !@registers['CMP'].positive?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if last comparise was not equal
  def call_jne(reg_key, addr, i_reg, m_spec)
    if !@registers['CMP'].zero?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if last comparise was greater or equal
  def call_jge(reg_key, addr, i_reg, m_spec)
    if !@registers['CMP'].negative?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if register is negative
  def call_jn(reg_key, addr, i_reg, m_spec)
    if @registers[reg_key].negative?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if register is zero
  def call_jz(reg_key, addr, i_reg, m_spec)
    if @registers[reg_key].zero?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if register is positive
  def call_jp(reg_key, addr, i_reg, m_spec)
    if @registers[reg_key].positive?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if register is not negative
  def call_jnn(reg_key, addr, i_reg, m_spec)
    if !@registers[reg_key].negative?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if register is not zero
  def call_jnz(reg_key, addr, i_reg, m_spec)
    if !@registers[reg_key].zero?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if register is not positive
  def call_jnp(reg_key, addr, i_reg, m_spec)
    if !@registers[reg_key].positive?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Copies N words from one address to another
  #
  # reg_key isn't used
  # addr + value at i_reg will be starting address for writing
  # I1 register is the starting address for reading
  # m_spec is number of words to write
  def call_move(reg_key, addr, i_reg, m_spec)
    to_addr = get_mem_addr(addr, i_reg)
    from_addr = @registers['I1'].word.to_i

    (0..(m_spec - 1)).each do |i|
      @computer.memory.write(to_addr + i, @computer.memory.read(from_addr + i))
    end
  end

  # Shift N bytes to the left on the A register
  def call_sla(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    (1..mem_addr).each do |i|
      @registers['A'].word.shift_left
    end
  end

  # Shift N bytes to the right on the A register
  def call_sra(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    (1..mem_addr).each do |i|
      @registers['A'].word.shift_right
    end
  end

  # Shift N bytes to the left, treating A and X registers
  # as a single word. 
  def call_slax(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    (1..mem_addr).each do |i|
      @registers['A'].word.shift_left
      val = @registers['X'].word.shift_left
      @registers['A'].word.value[5] = val
    end
  end

  # Shift N bytes to the right, treating A and X registers
  # as a single word. 
  def call_srax(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    (1..mem_addr).each do |i|
      val = @registers['A'].word.shift_right
      @registers['X'].word.shift_right
      @registers['X'].word.value[1] = val
    end
  end

  # Shift left with carry (rotate) on A register
  def call_slc(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    (1..mem_addr).each do |i|
      @registers['A'].word.rotate_left
    end
  end

  # Shift right with carry (rotate) on A register
  def call_src(reg_key, addr, i_reg, m_spec)
    mem_addr = get_mem_addr(addr, i_reg)
    (1..mem_addr).each do |i|
      @registers['A'].word.rotate_right
    end
  end

  # Does nothing
  def call_nop(reg_key, addr, i_reg, m_spec)
  end

  # Terminates the program
  def call_hlt(reg_key, addr, i_reg, m_spec)
    @pc = nil
  end

  # Read from a device to memory
  def call_in(reg_key, addr, i_reg, device_num)
    to_addr = get_mem_addr(addr, i_reg)
    dev = @computer.get_device(device_num)
    word = dev.read
    @computer.memory.write(to_addr, word)
  end

  # Write from memory to a device
  def call_out(reg_key, addr, i_reg, device_num)
    word = @computer.memory.read( get_mem_addr(addr, i_reg) )
    dev = @computer.get_device(device_num)
    dev.write(word)
  end

  # Sends a control instruction to a device
  def call_ioc(reg_key, addr, i_reg, device_num)
    change_amount = get_mem_addr(addr, i_reg)
    dev = @computer.get_device(device_num)
    dev.move_word_pointer(change_amount)
  end

  # Jump if a device is ready
  def call_jred(reg_key, addr, i_reg, device_num)
    dev = @computer.get_device(device_num)
    if dev.ready?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # Jump if a device is busy
  def call_jbus(reg_key, addr, i_reg, device_num)
    dev = @computer.get_device(device_num)
    if dev.busy?
      @pc = get_mem_addr(addr, i_reg)
    end
  end

  # I am not really sure what to do with num and char because
  # all words are: numeric values, character values and 
  # MIXAL instructions.

  # Numerical representation in registers A and X
  def call_num(reg_key, addr, i_reg, m_spec)
  end

  # Character representation of registers A and X
  def call_char(reg_key, addr, i_reg, m_spec)
  end


  # Directive definitions
  


private

  def get_mem_addr(addr, i_reg)
    mem_addr = addr
    mem_addr += i_reg.word.to_i if i_reg
    mem_addr
  end
end
