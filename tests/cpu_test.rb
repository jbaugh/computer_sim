
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
    assert_equal(Word.default(3), @cpu.registers['CMP'].value, 'Register resetting')

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
end
