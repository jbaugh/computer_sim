
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

  def test_execute_operation

  end
end
