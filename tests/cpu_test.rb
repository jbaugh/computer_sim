
require 'test/unit'
load 'computer.rb'

class CPUTest < Test::Unit::TestCase
  def setup
    @computer = Computer.new
  end

  
  def test_reset
    @computer.cpu.reset

    assert_equal(Word.default(5), @computer.cpu.registers['A'].value, 'Register resetting')
    assert_equal(Word.default(5), @computer.cpu.registers['X'].value, 'Register resetting')
    assert_equal(Word.default(2), @computer.cpu.registers['J'].value, 'Register resetting')
    assert_equal(Word.default(3), @computer.cpu.registers['CMP'].value, 'Register resetting')

    assert_equal(Word.default(2), @computer.cpu.registers['I1'].value, 'Register resetting')
    assert_equal(Word.default(2), @computer.cpu.registers['I2'].value, 'Register resetting')
    assert_equal(Word.default(2), @computer.cpu.registers['I3'].value, 'Register resetting')  
    assert_equal(Word.default(2), @computer.cpu.registers['I4'].value, 'Register resetting')
    assert_equal(Word.default(2), @computer.cpu.registers['I5'].value, 'Register resetting')
    assert_equal(Word.default(2), @computer.cpu.registers['I6'].value, 'Register resetting')
  end

  
end
