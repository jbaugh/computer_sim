
require 'test/unit'
load 'op_code.rb'

class OpCodeTest < Test::Unit::TestCase
  
  def test_get_byte
    assert_equal(2, OpCode.get_byte('LD1'), 'Get byte')
    assert_equal(135, OpCode.get_byte('UNKNOWN'), 'Get byte')
    assert_equal(2, OpCode.get_byte('ld1'), 'Get byte lowercase')
  end

  def test_get_command
    assert_equal('LD1', OpCode.get_command(2), 'Get command')
    assert_equal('NOP', OpCode.get_command(-99999), 'Get command')
  end

  def test_lossless_gets
    assert_equal('LD1', OpCode.get_command(OpCode.get_byte('LD1')), 'Lossless gets')
    assert_equal('MOVE', OpCode.get_command(OpCode.get_byte('MOVE')), 'Lossless gets')
    assert_equal('J3Z', OpCode.get_command(OpCode.get_byte('J3Z')), 'Lossless gets')
    assert_equal('SLAX', OpCode.get_command(OpCode.get_byte('SLAX')), 'Lossless gets')
    assert_equal('JANN', OpCode.get_command(OpCode.get_byte('jann')), 'Lossless gets with lowercase')
  end  
end