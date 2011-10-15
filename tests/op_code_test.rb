
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
  
  def test_get_command_type
    assert_equal('LD', OpCode.get_command_type('LDA'), 'Command type parses out command correctly')
    assert_equal('LDN', OpCode.get_command_type('LDAN'), 'Command type parses out command correctly')
    assert_equal('ST', OpCode.get_command_type('ST1'), 'Command type parses out command correctly')
    assert_equal('ADD', OpCode.get_command_type('ADD'), 'Command type parses out command correctly')
    assert_equal('SUB', OpCode.get_command_type('SUB'), 'Command type parses out command correctly')
    assert_equal('MUL', OpCode.get_command_type('MUL'), 'Command type parses out command correctly')
    assert_equal('DIV', OpCode.get_command_type('DIV'), 'Command type parses out command correctly')

    assert_equal('ENT', OpCode.get_command_type('ENT2'), 'Command type parses out command correctly')
    assert_equal('ENN', OpCode.get_command_type('ENNA'), 'Command type parses out command correctly')
    assert_equal('INC', OpCode.get_command_type('INC3'), 'Command type parses out command correctly')
    assert_equal('DEC', OpCode.get_command_type('DECX'), 'Command type parses out command correctly')
    assert_equal('CMP', OpCode.get_command_type('CMP5'), 'Command type parses out command correctly')
    
    assert_equal('JMP', OpCode.get_command_type('JMP'), 'Command type parses out command correctly')
    assert_equal('JSJ', OpCode.get_command_type('JSJ'), 'Command type parses out command correctly')
    assert_equal('JOV', OpCode.get_command_type('JOV'), 'Command type parses out command correctly')
    assert_equal('JNOV', OpCode.get_command_type('JNOV'), 'Command type parses out command correctly')

    assert_equal('JL', OpCode.get_command_type('JL'), 'Command type parses out command correctly')
    assert_equal('JE', OpCode.get_command_type('JE'), 'Command type parses out command correctly')
    assert_equal('JG', OpCode.get_command_type('JG'), 'Command type parses out command correctly')
    assert_equal('JLE', OpCode.get_command_type('JLE'), 'Command type parses out command correctly')
    assert_equal('JNE', OpCode.get_command_type('JNE'), 'Command type parses out command correctly')
    assert_equal('JGE', OpCode.get_command_type('JGE'), 'Command type parses out command correctly')

    assert_equal('JN', OpCode.get_command_type('JAN'), 'Command type parses out command correctly')
    assert_equal('JZ', OpCode.get_command_type('JXZ'), 'Command type parses out command correctly')
    assert_equal('JP', OpCode.get_command_type('J3P'), 'Command type parses out command correctly')
    assert_equal('JNN', OpCode.get_command_type('J5NN'), 'Command type parses out command correctly')
    assert_equal('JNZ', OpCode.get_command_type('J6NZ'), 'Command type parses out command correctly')
    assert_equal('JNP', OpCode.get_command_type('J2NP'), 'Command type parses out command correctly')

    assert_equal('MOVE', OpCode.get_command_type('MOVE'), 'Command type parses out command correctly')
    assert_equal('SLA', OpCode.get_command_type('SLA'), 'Command type parses out command correctly')
    assert_equal('SRA', OpCode.get_command_type('SRA'), 'Command type parses out command correctly')
    assert_equal('SLAX', OpCode.get_command_type('SLAX'), 'Command type parses out command correctly')
    assert_equal('SRAX', OpCode.get_command_type('SRAX'), 'Command type parses out command correctly')
    assert_equal('SLC', OpCode.get_command_type('SLC'), 'Command type parses out command correctly')
    assert_equal('SRC', OpCode.get_command_type('SRC'), 'Command type parses out command correctly')
    assert_equal('NOP', OpCode.get_command_type('NOP'), 'Command type parses out command correctly')
    assert_equal('HLT', OpCode.get_command_type('HLT'), 'Command type parses out command correctly')
    assert_equal('IN', OpCode.get_command_type('IN'), 'Command type parses out command correctly')
    assert_equal('OUT', OpCode.get_command_type('OUT'), 'Command type parses out command correctly')
    assert_equal('IOC', OpCode.get_command_type('IOC'), 'Command type parses out command correctly')
    assert_equal('JRED', OpCode.get_command_type('JRED'), 'Command type parses out command correctly')
    assert_equal('JBUS', OpCode.get_command_type('JBUS'), 'Command type parses out command correctly')
    assert_equal('NUM', OpCode.get_command_type('NUM'), 'Command type parses out command correctly')
    assert_equal('CHAR', OpCode.get_command_type('CHAR'), 'Command type parses out command correctly')

    assert_equal('NOP', OpCode.get_command_type(''), 'Command type returns nil on invalid input')
    assert_equal('NOP', OpCode.get_command_type('FOO'), 'Command type returns nil on invalid input')
    assert_equal('NOP', OpCode.get_command_type(nil), 'Command type returns nil on invalid input')
    assert_equal('NOP', OpCode.get_command_type(5), 'Command type returns nil on invalid input')
  end  
end
