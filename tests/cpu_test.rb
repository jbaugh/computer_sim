
require 'test/unit'
load 'computer.rb'

class CPUTest < Test::Unit::TestCase
  def setup
    @computer = Computer.new
    @cpu = @computer.cpu
  end

  def test_parse_line
    @cpu.parse_line('LDA 2000,1(0:5)')
    assert_equal('+', @cpu.op[0], 'Parse line')
    assert_equal(20, @cpu.op[1], 'Parse line')
    assert_equal(0, @cpu.op[2], 'Parse line')
    assert_equal(1, @cpu.op[3], 'Parse line')
    assert_equal(0, @cpu.op[4], 'Parse line')
    assert_equal(0, @cpu.op[5], 'Parse line')
  end
  
  def test_reset
    @computer.cpu.reset

    assert_equal(Word.default(5), @cpu.registers['A'].value, 'Register resetting')
    assert_equal(Word.default(5), @cpu.registers['X'].value, 'Register resetting')
    assert_equal(Word.default(2), @cpu.registers['J'].value, 'Register resetting')
    assert_equal(Word.default(1), @cpu.registers['CMP'].value, 'Register resetting')
    assert_equal(Word.default(1), @cpu.registers['OV'].value, 'Register resetting')

    assert_equal(Word.default(2), @cpu.registers['I1'].value, 'Register resetting')
    assert_equal(Word.default(2), @cpu.registers['I2'].value, 'Register resetting')
    assert_equal(Word.default(2), @cpu.registers['I3'].value, 'Register resetting')  
    assert_equal(Word.default(2), @cpu.registers['I4'].value, 'Register resetting')
    assert_equal(Word.default(2), @cpu.registers['I5'].value, 'Register resetting')
    assert_equal(Word.default(2), @cpu.registers['I6'].value, 'Register resetting')
  end

  def test_call_ld
    @computer.memory.storage[2000].value = ['+',0,1,2,3,4]
    @cpu.call_ld('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(['+',0,1,2,3,4], @cpu.registers['A'].value, 'Simple ld')

    @computer.memory.storage[2000].value = ['+',2,1,2,3,4]
    @cpu.call_ld('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(['+',2,1,2,3,4], @cpu.registers['A'].value, 'Simple ld')

    @computer.memory.storage[2000].value = ['+',2,1,2,3,4]
    @cpu.call_ld('A', 2000, nil, ModSpec.get_command(9))
    assert_equal(['+',2,1,0,0,0], @cpu.registers['A'].value, 'Simple ld')

    @computer.memory.storage[2000].value = ['+',2,1,2,3,4]
    @cpu.call_ld('A', 2000, nil, ModSpec.get_command(13))
    assert_equal(['+',0,1,2,0,0], @cpu.registers['A'].value, 'Simple ld')
  end

  def test_call_ldn
    @computer.memory.storage[2000].value = ['+',0,1,2,3,4]
    @cpu.call_ldn('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(['-',0,1,2,3,4], @cpu.registers['A'].value, 'Simple ldn')

    @computer.memory.storage[2000].value = ['-',2,1,2,3,4]
    @cpu.call_ldn('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(['+',2,1,2,3,4], @cpu.registers['A'].value, 'Simple ldn')

    @computer.memory.storage[2000].value = ['+',2,1,2,3,4]
    @cpu.call_ldn('A', 2000, nil, ModSpec.get_command(9))
    assert_equal(['-',2,1,0,0,0], @cpu.registers['A'].value, 'Simple ldn')

    @computer.memory.storage[2000].value = ['+',2,1,2,3,4]
    @cpu.call_ldn('A', 2000, nil, ModSpec.get_command(13))
    assert_equal(['-',0,1,2,0,0], @cpu.registers['A'].value, 'Simple ldn')
  end

  def test_call_st
    @word = @computer.memory.storage[2000]
    @register = @cpu.registers['A']
    
    @word.reset
    @register.value = ['+',0,1,2,3,4]
    @cpu.call_st('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(['+',0,1,2,3,4], @word.value, 'Simple st')

    @word.reset
    @register.value = ['+',4,1,0,3,1]
    @cpu.call_st('A', 2000, nil, ModSpec.get_command(9))
    assert_equal(['+',4,1,0,0,0], @word.value, 'Simple st')
  end

  def test_call_add
    @register = @cpu.registers['A']
    @word = @computer.memory.storage[2000]

    @register.reset
    @word.from_int(184)
    @cpu.call_add(nil, 2000, nil, ModSpec.get_command(0))
    assert_equal(184, @register.word.to_i, "Addition of a word")

    @register.word.from_int(300)
    @word.from_int(184)
    @cpu.call_add(nil, 2000, nil, ModSpec.get_command(0))
    assert_equal(484, @register.word.to_i, "Addition of a word")
  end

  def test_call_sub
    @register = @cpu.registers['A']
    @word = @computer.memory.storage[2000]

    @register.reset
    @word.from_int(17)
    @cpu.call_sub(nil, 2000, nil, ModSpec.get_command(0))
    assert_equal(-17, @register.word.to_i, "Subtraction of a word")

    @register.word.from_int(100)
    @word.from_int(17)
    @cpu.call_sub(nil, 2000, nil, ModSpec.get_command(0))
    assert_equal(83, @register.word.to_i, "Subtraction of a word")
  end

  def test_call_mul
    @register_a = @cpu.registers['A']
    @register_x = @cpu.registers['X']
    @word = @computer.memory.storage[2000]

    @register_a.word.from_int(3)
    @register_x.reset
    @word.from_int(5)
    @cpu.call_mul(nil, 2000, nil, ModSpec.get_command(0))
    assert_equal(15, @register_a.word.to_i, "Multiplication of a word")

    @register_a.word.from_int(30)
    @register_x.reset
    @word.from_int(-5)
    @cpu.call_mul(nil, 2000, nil, ModSpec.get_command(0))
    assert_equal(-150, @register_a.word.to_i, "Multiplication of a word")
  end

  def test_call_div
    @register_a = @cpu.registers['A']
    @register_x = @cpu.registers['X']
    @word = @computer.memory.storage[2000]

    @register_a.word.from_int(60)
    @register_x.reset
    @word.from_int(15)
    @cpu.call_div(nil, 2000, nil, ModSpec.get_command(0))
    assert_equal(4, @register_a.word.to_i, "Division of a word")
    assert_equal(0, @register_x.word.to_i, "Modulo of a word")

    @register_a.word.from_int(31)
    @register_x.reset
    @word.from_int(-5)
    @cpu.call_div(nil, 2000, nil, ModSpec.get_command(0))
    assert_equal(-7, @register_a.word.to_i, "Division of a word")
    assert_equal(-4, @register_x.word.to_i, "Modulo of a word")

    @register_a.word.from_int(31)
    @register_x.reset
    @word.from_int(5)
    @cpu.call_div(nil, 2000, nil, ModSpec.get_command(0))
    assert_equal(6, @register_a.word.to_i, "Division of a word")
    assert_equal(1, @register_x.word.to_i, "Modulo of a word")
  end

  def test_call_ent
    @cpu.call_ent('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(2000, @cpu.registers['A'].word.to_i, "Assigning a value to a register")

    @cpu.call_ent('X', 750, nil, ModSpec.get_command(0))
    assert_equal(750, @cpu.registers['X'].word.to_i, "Assigning a value to a register")

    @cpu.registers['I1'].word.from_int(33)
    @cpu.call_ent('I3', 100, @cpu.registers['I1'], ModSpec.get_command(0))
    assert_equal(133, @cpu.registers['I3'].word.to_i, "Assigning a value to a register")
  end

  def test_call_enn
    @cpu.call_enn('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(-2000, @cpu.registers['A'].word.to_i, "Assigning a value to a register")

    @cpu.call_enn('X', 750, nil, ModSpec.get_command(0))
    assert_equal(-750, @cpu.registers['X'].word.to_i, "Assigning a value to a register")

    @cpu.registers['I1'].word.from_int(33)
    @cpu.call_enn('I3', 100, @cpu.registers['I1'], ModSpec.get_command(0))
    assert_equal(-133, @cpu.registers['I3'].word.to_i, "Assigning a value to a register")
  end

  def test_call_inc
    @cpu.registers['A'].reset
    @cpu.call_inc('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(2000, @cpu.registers['A'].word.to_i, "Incrementing a register")

    @cpu.registers['A'].word.from_int(-100)
    @cpu.call_inc('A', 750, nil, ModSpec.get_command(0))
    assert_equal(650, @cpu.registers['A'].word.to_i, "Incrementing a register")

    @cpu.registers['I3'].word.from_int(100)
    @cpu.registers['I1'].word.from_int(33)
    @cpu.call_inc('I3', 100, @cpu.registers['I1'], ModSpec.get_command(0))
    assert_equal(233, @cpu.registers['I3'].word.to_i, "Incrementing a register")
  end

  def test_call_dec
    @cpu.registers['A'].reset
    @cpu.call_dec('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(-2000, @cpu.registers['A'].word.to_i, "Decrementing a register")

    @cpu.registers['A'].word.from_int(100)
    @cpu.call_dec('A', 750, nil, ModSpec.get_command(0))
    assert_equal(-650, @cpu.registers['A'].word.to_i, "Decrementing a register")

    @cpu.registers['I3'].word.from_int(100)
    @cpu.registers['I1'].word.from_int(33)
    @cpu.call_dec('I3', 100, @cpu.registers['I1'], ModSpec.get_command(0))
    assert_equal(-33, @cpu.registers['I3'].word.to_i, "Decrementing a register")
  end

  def test_call_cmp
    @cpu.registers['A'].word.from_int(300)
    @computer.memory.storage[2000].from_int(150)
    @cpu.call_cmp('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(true, @cpu.registers['CMP'].positive?, "Greater than?")
    assert_equal(false, @cpu.registers['CMP'].negative?, "Less than?")
    assert_equal(false, @cpu.registers['CMP'].zero?, "Equal to?")

    @cpu.registers['A'].word.from_int(-33)
    @computer.memory.storage[2000].from_int(-33)
    @cpu.call_cmp('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(false, @cpu.registers['CMP'].positive?, "Greater than?")
    assert_equal(false, @cpu.registers['CMP'].negative?, "Less than?")
    assert_equal(true, @cpu.registers['CMP'].zero?, "Equal to?")

    @cpu.registers['A'].word.from_int(-15)
    @computer.memory.storage[2000].from_int(150)
    @cpu.call_cmp('A', 2000, nil, ModSpec.get_command(0))
    assert_equal(false, @cpu.registers['CMP'].positive?, "Greater than?")
    assert_equal(true, @cpu.registers['CMP'].negative?, "Less than?")
    assert_equal(false, @cpu.registers['CMP'].zero?, "Equal to?")
  end

  def test_call_jmp
    @cpu.call_jmp(nil, 2000, nil, nil)
    assert_equal(2000, @cpu.registers['J'].word.to_i, "Jump register")
    assert_equal(2000, @cpu.pc, "Program counter")
    
    @cpu.registers['I1'].word.from_int(50)
    @cpu.call_jmp(nil, 100, @cpu.registers['I1'], nil)
    assert_equal(150, @cpu.registers['J'].word.to_i, "Jump register")
    assert_equal(150, @cpu.pc, "Program counter")
  end

  def test_call_jsj
    @cpu.call_jsj(nil, 2000, nil, nil)
    assert_equal(Word.default(2), @cpu.registers['J'].word.value, "Jump register")
    assert_equal(2000, @cpu.pc, "Program counter")
    
    @cpu.registers['I1'].word.from_int(50)
    @cpu.call_jsj(nil, 100, @cpu.registers['I1'], nil)
    assert_equal(Word.default(2), @cpu.registers['J'].word.value, "Jump register")
    assert_equal(150, @cpu.pc, "Program counter")
  end

  def test_call_jov
    @cpu.registers['OV'].value[1] = 1
    @cpu.call_jov(nil, 100, nil, nil)
    assert_equal(100, @cpu.pc, "Program counter changes if overflowed")

    @cpu.registers['I1'].word.from_int(50)
    @cpu.call_jov(nil, 100, @cpu.registers['I1'], nil)
    assert_equal(150, @cpu.pc, "Program counter changes if overflowed")

    @cpu.registers['OV'].value[1] = 0
    @cpu.call_jov(nil, 100, nil, nil)
    assert_equal(150, @cpu.pc, "Program counter doesnt change if not overflowed")

    @cpu.registers['I1'].word.from_int(50)
    @cpu.call_jov(nil, 100, @cpu.registers['I1'], nil)
    assert_equal(150, @cpu.pc, "Program counter doesnt change if not overflowed")
  end

  def test_call_jnov
    @cpu.registers['OV'].value[1] = 0
    @cpu.call_jnov(nil, 100, nil, nil)
    assert_equal(100, @cpu.pc, "Program counter changes if not overflowed")

    @cpu.registers['I1'].word.from_int(50)
    @cpu.call_jnov(nil, 100, @cpu.registers['I1'], nil)
    assert_equal(150, @cpu.pc, "Program counter changes if not overflowed")

    @cpu.registers['OV'].value[1] = 1
    @cpu.call_jnov(nil, 100, nil, nil)
    assert_equal(150, @cpu.pc, "Program counter doesnt change if overflowed")

    @cpu.registers['I1'].word.from_int(50)
    @cpu.call_jnov(nil, 100, @cpu.registers['I1'], nil)
    assert_equal(150, @cpu.pc, "Program counter doesnt change if overflowed")
  end

  def test_call_jl
    @cpu.registers['CMP'].value = ['-',1]
    @cpu.call_jl(nil, 150, nil, nil)
    assert_equal(150, @cpu.pc, "Jump if cmp is less")

    @cpu.pc = 0
    @cpu.registers['CMP'].value = ['+',1]
    @cpu.call_jl(nil, 150, nil, nil)
    assert_equal(0, @cpu.pc, "Dont jump if cmp is greater")
  end

  def test_call_je
    @cpu.registers['CMP'].value = ['-',0]
    @cpu.call_je(nil, 150, nil, nil)
    assert_equal(150, @cpu.pc, "Jump if cmp is equal")

    @cpu.pc = 0
    @cpu.registers['CMP'].value = ['+',1]
    @cpu.call_je(nil, 150, nil, nil)
    assert_equal(0, @cpu.pc, "Dont jump if cmp is not equal")
  end

  def test_call_jg
    @cpu.registers['CMP'].value = ['+',1]
    @cpu.call_jg(nil, 150, nil, nil)
    assert_equal(150, @cpu.pc, "Jump if cmp is greater")

    @cpu.pc = 0
    @cpu.registers['CMP'].value = ['-',1]
    @cpu.call_jg(nil, 150, nil, nil)
    assert_equal(0, @cpu.pc, "Dont jump if cmp is lesser")
  end

  def test_call_jle
    @cpu.registers['CMP'].value = ['-',1]
    @cpu.call_jle(nil, 150, nil, nil)
    assert_equal(150, @cpu.pc, "Jump if cmp is less")

    @cpu.pc = 0
    @cpu.registers['CMP'].value = ['-',0]
    @cpu.call_jle(nil, 150, nil, nil)
    assert_equal(150, @cpu.pc, "Jump if cmp is equal")

    @cpu.pc = 0
    @cpu.registers['CMP'].value = ['+',1]
    @cpu.call_jle(nil, 150, nil, nil)
    assert_equal(0, @cpu.pc, "Dont jump if cmp is greater")
  end

  def test_call_jne
    @cpu.registers['CMP'].value = ['-',1]
    @cpu.call_jne(nil, 150, nil, nil)
    assert_equal(150, @cpu.pc, "Jump if cmp is not equal")

    @cpu.pc = 0
    @cpu.registers['CMP'].value = ['_',1]
    @cpu.call_jne(nil, 150, nil, nil)
    assert_equal(150, @cpu.pc, "Jump if cmp is not equal")

    @cpu.pc = 0
    @cpu.registers['CMP'].value = ['+',0]
    @cpu.call_jne(nil, 150, nil, nil)
    assert_equal(0, @cpu.pc, "Dont jump if cmp is equal")
  end

  def test_call_jge
    @cpu.registers['CMP'].value = ['+',1]
    @cpu.call_jge(nil, 150, nil, nil)
    assert_equal(150, @cpu.pc, "Jump if cmp is greater")

    @cpu.pc = 0
    @cpu.registers['CMP'].value = ['+',0]
    @cpu.call_jge(nil, 150, nil, nil)
    assert_equal(150, @cpu.pc, "Jump if cmp is equal")

    @cpu.pc = 0
    @cpu.registers['CMP'].value = ['-',1]
    @cpu.call_jge(nil, 150, nil, nil)
    assert_equal(0, @cpu.pc, "Dont jump if cmp is lesser")
  end

  def test_call_jn
    @cpu.registers['A'].word.from_int(-300)
    @cpu.call_jn('A', 150, nil, 0)
    assert_equal(150, @cpu.pc, "Jump if negative")

    @cpu.pc = 0
    @cpu.registers['A'].word.from_int(300)
    @cpu.call_jn('A', 150, nil, 0)
    assert_equal(0, @cpu.pc, "Dont jump if positive")
  end

  def test_call_jz
    @cpu.registers['A'].word.from_int(0)
    @cpu.call_jz('A', 150, nil, 0)
    assert_equal(150, @cpu.pc, "Jump if zero")

    @cpu.pc = 0
    @cpu.registers['A'].word.from_int(300)
    @cpu.call_jz('A', 150, nil, 0)
    assert_equal(0, @cpu.pc, "Dont jump if not zero")
  end

  def test_call_jp
    @cpu.registers['A'].word.from_int(300)
    @cpu.call_jp('A', 150, nil, 0)
    assert_equal(150, @cpu.pc, "Jump if positive")

    @cpu.pc = 0
    @cpu.registers['A'].word.from_int(-300)
    @cpu.call_jp('A', 150, nil, 0)
    assert_equal(0, @cpu.pc, "Dont jump if negative")
  end

  def test_call_jnn
    @cpu.registers['A'].word.from_int(300)
    @cpu.call_jnn('A', 150, nil, 0)
    assert_equal(150, @cpu.pc, "Jump if not negative")

    @cpu.pc = 0
    @cpu.registers['A'].word.from_int(-300)
    @cpu.call_jnn('A', 150, nil, 0)
    assert_equal(0, @cpu.pc, "Dont jump if negative")
  end

  def test_call_jnz
    @cpu.registers['A'].word.from_int(50)
    @cpu.call_jnz('A', 150, nil, 0)
    assert_equal(150, @cpu.pc, "Jump if not zero")

    @cpu.pc = 0
    @cpu.registers['A'].word.from_int(0)
    @cpu.call_jnz('A', 150, nil, 0)
    assert_equal(0, @cpu.pc, "Dont jump if zero")
  end

  def test_call_jnp
    @cpu.registers['A'].word.from_int(0)
    @cpu.call_jnp('A', 150, nil, 0)
    assert_equal(150, @cpu.pc, "Jump if not positive")

    @cpu.pc = 0
    @cpu.registers['A'].word.from_int(17)
    @cpu.call_jnp('A', 150, nil, 0)
    assert_equal(0, @cpu.pc, "Dont jump if positive")
  end

  def test_call_move
    @cpu.registers['I1'].word.from_int(10)

    @computer.memory.storage[10].from_int(150)
    @cpu.call_move(nil, 20, nil, 1)
    assert_equal(150, @computer.memory.storage[20].to_i, 'Moving a word')

    @computer.memory.storage[10].from_int(150)
    @computer.memory.storage[11].from_int(33)
    @computer.memory.storage[12].from_int(77)
    @cpu.call_move(nil, 20, nil, 3)
    assert_equal(150, @computer.memory.storage[20].to_i, 'Moving a word')
    assert_equal(33, @computer.memory.storage[21].to_i, 'Moving a word')
    assert_equal(77, @computer.memory.storage[22].to_i, 'Moving a word')
  end

  def test_call_sla
    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.call_sla(nil, 1, nil, 0)
    assert_equal(['+',2,3,4,5,0], @cpu.registers['A'].word.value, "Shifting to the left")

    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.call_sla(nil, 2, nil, 0)
    assert_equal(['+',3,4,5,0,0], @cpu.registers['A'].word.value, "Shifting to the left 2 times")
  end

  def test_call_sra
    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.call_sra(nil, 1, nil, 0)
    assert_equal(['+',0,1,2,3,4], @cpu.registers['A'].word.value, "Shifting to the right")

    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.call_sra(nil, 2, nil, 0)
    assert_equal(['+',0,0,1,2,3], @cpu.registers['A'].word.value, "Shifting to the right 2 times")
  end

  def test_call_slax
    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.registers['X'].word.value = ['+',6,7,8,9,10]
    @cpu.call_slax(nil, 1, nil, 0)
    assert_equal(['+',2,3,4,5,6], @cpu.registers['A'].word.value, "Shifting AX to the left")
    assert_equal(['+',7,8,9,10,0], @cpu.registers['X'].word.value, "Shifting AX to the left")

    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.registers['X'].word.value = ['+',6,7,8,9,10]
    @cpu.call_slax(nil, 2, nil, 0)
    assert_equal(['+',3,4,5,6,7], @cpu.registers['A'].word.value, "Shifting AX to the left 2 times")
    assert_equal(['+',8,9,10,0,0], @cpu.registers['X'].word.value, "Shifting AX to the left 2 times")
  end

  def test_call_srax
    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.registers['X'].word.value = ['+',6,7,8,9,10]
    @cpu.call_srax(nil, 1, nil, 0)
    assert_equal(['+',0,1,2,3,4], @cpu.registers['A'].word.value, "Shifting AX to the right")
    assert_equal(['+',5,6,7,8,9], @cpu.registers['X'].word.value, "Shifting AX to the right")

    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.registers['X'].word.value = ['+',6,7,8,9,10]
    @cpu.call_srax(nil, 2, nil, 0)
    assert_equal(['+',0,0,1,2,3], @cpu.registers['A'].word.value, "Shifting AX to the right 2 times")
    assert_equal(['+',4,5,6,7,8], @cpu.registers['X'].word.value, "Shifting AX to the right 2 times")
  end

  def test_call_slc
    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.call_slc(nil, 1, nil, 0)
    assert_equal(['+',2,3,4,5,1], @cpu.registers['A'].word.value, "Rotating to the left")

    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.call_slc(nil, 2, nil, 0)
    assert_equal(['+',3,4,5,1,2], @cpu.registers['A'].word.value, "Rotating to the left 2 times")
  end

  def test_call_src
    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.call_src(nil, 1, nil, 0)
    assert_equal(['+',5,1,2,3,4], @cpu.registers['A'].word.value, "Rotating to the right")

    @cpu.registers['A'].word.value = ['+',1,2,3,4,5]
    @cpu.call_src(nil, 2, nil, 0)
    assert_equal(['+',4,5,1,2,3], @cpu.registers['A'].word.value, "Rotating to the right 2 times")
  end
end
