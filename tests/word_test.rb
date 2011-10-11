
require 'test/unit'
load 'word.rb'
      
 class WordTest < Test::Unit::TestCase
    def setup
      @word = Word.new(5)
    end
  
  def test_to_i
    assert_equal(0, @word.to_i, 'Default word to integer')

    @word.value = ['-',0,0,0,0,0]
    assert_equal(0, @word.to_i, 'Negative 0 to integer')
 
    @word.value = ['+',0,0,5,2,88]
    assert_equal(50288, @word.to_i, 'Positive word to integer')  
    
    @word.value = ['+',0,1,5,2,88]
    assert_equal(1050288, @word.to_i, 'Positive word to integer')

    @word.value = ['+',0,31,5,2,00]
    assert_equal(31050200, @word.to_i, 'Positive word to integer')
 
    @word.value = ['-',1,0,0,0,1]
    assert_equal(-100000001, @word.to_i, 'Negative word to integer')
 
    @word.value = ['-',0,0,0,1,31]
    assert_equal(-131, @word.to_i, 'Negative word to integer')

    @word = Word.new(2)
    @word.value = ['+',1,31]
    assert_equal(131, @word.to_i, 'Smaller word to integer')
  end

  def test_from_int
    @word.reset

    val = 0
    assert_equal(['+',0,0,0,0,0], @word.from_int(val).value, 'Default integer to word')

    val = 101
    assert_equal(['+',0,0,0,1,1], @word.from_int(val).value, 'Positive integer to word')
    assert_equal(false, @word.overflowed?, 'Should not overflow')

    val = -5020
    assert_equal(['-',0,0,0,50,20], @word.from_int(val).value, 'Negative integer to word')
    assert_equal(false, @word.overflowed?, 'Should not overflow')

    val = 10000000001
    assert_equal(['+',0,0,0,0,1], @word.from_int(val).value, 'Overflowing positive integer to word')
    assert_equal(true, @word.overflowed?, 'Should overflow')

    val = -10000000001
    assert_equal(['-',0,0,0,0,1], @word.from_int(val).value, 'Overflowing negative integer to word')
    assert_equal(true, @word.overflowed?, 'Should overflow')
  end

  def test_from_string
    @word.reset

    @word.from_string('LDA 2000,1(0:5)')
    assert_equal('+', @word.value[0], 'Parse from string')
    assert_equal(20, @word.value[1], 'Parse from string')
    assert_equal(0, @word.value[2], 'Parse from string')
    assert_equal(1, @word.value[3], 'Parse from string')
    assert_equal(0, @word.value[4], 'Parse from string')
    assert_equal(0, @word.value[5], 'Parse from string')

    @word.from_string('JXNP 3999,3(3:5)')
    assert_equal('+', @word.value[0], 'Parse from string')
    assert_equal(39, @word.value[1], 'Parse from string')
    assert_equal(99, @word.value[2], 'Parse from string')
    assert_equal(3, @word.value[3], 'Parse from string')
    assert_equal(15, @word.value[4], 'Parse from string')
    assert_equal(91, @word.value[5], 'Parse from string')

    @word.from_string('LDA 21,0(0:5)')
    assert_equal('+', @word.value[0], 'Parse from string')
    assert_equal(0, @word.value[1], 'Parse from string')
    assert_equal(21, @word.value[2], 'Parse from string')
    assert_equal(0, @word.value[3], 'Parse from string')
    assert_equal(0, @word.value[4], 'Parse from string')
    assert_equal(0, @word.value[5], 'Parse from string')
  end

  def test_to_s
    @word.value = ['+', 20, 0, 1, 0, 0]
    assert_equal('LDA 2000,1(0:5)', @word.to_str, 'Word to string')

    @word.value = ['+', 20, 50, 1, 3, 4]
    assert_equal('LD3 2050,1(0:2)', @word.to_str, 'Word to string')

    @word.value = ['-', 39, 99, 3, 15, 91]
    assert_equal('JXNP 3999,3(3:5)', @word.to_str, 'Word to string')
  end

  def test_self_default
    assert_equal(['+'], Word.default(0), 'Word default generator')
    assert_equal(['+', 0], Word.default(1), 'Word default generator')
    assert_equal(['+', 0, 0], Word.default(2), 'Word default generator')
    assert_equal(['+', 0, 0, 0], Word.default(3), 'Word default generator')
    assert_equal(['+', 0, 0, 0, 0], Word.default(4), 'Word default generator')
    assert_equal(['+', 0, 0, 0, 0, 0], Word.default(5), 'Word default generator')
  end

  def test_reset
    @word.value = ['-',0,0,0,1,31]
    @word.reset
    assert_equal(Word.default(5), @word.value, 'Resetting word uses default value')
    assert_equal(false, @word.overflowed?, 'Resetting word sets overflow flag to false')
  end

  def test_negate_sign
    @word.value = ['-',0,0,0,1,31]
    @word.negate_sign
    assert_equal('+', @word.sign, 'Negating the sign')

    @word.negate_sign
    assert_equal('-', @word.sign, 'Negating the sign')

    @word.value = ['+',0,0,0,1,31]
    @word.negate_sign
    assert_equal('-', @word.sign, 'Negating the sign')

    @word.negate_sign
    assert_equal('+', @word.sign, 'Negating the sign')
  end

  def test_parse_memory_address
    assert_equal(['00', '00'], @word.parse_memory_address('0000'), 'Parse memory address')
    assert_equal(['00', '01'], @word.parse_memory_address('0001'), 'Parse memory address')
    assert_equal(['00', '20'], @word.parse_memory_address('0020'), 'Parse memory address')
    assert_equal(['03', '00'], @word.parse_memory_address('0300'), 'Parse memory address')
    assert_equal(['40', '00'], @word.parse_memory_address('4000'), 'Parse memory address')
    assert_equal(['12', '34'], @word.parse_memory_address('1234'), 'Parse memory address')
    assert_equal(['00', '01'], @word.parse_memory_address('1'), 'Parse memory address')
    assert_equal(['00', '21'], @word.parse_memory_address('21'), 'Parse memory address')
    assert_equal(['03', '21'], @word.parse_memory_address('321'), 'Parse memory address')
    assert_equal(['00', '00'], @word.parse_memory_address('0'), 'Parse memory address')
  end
  
  def test_parse_index_spec
    assert_equal(0, @word.parse_index_spec('0'), 'Parse index spec')
    assert_equal(1, @word.parse_index_spec('1'), 'Parse index spec')
    assert_equal(0, @word.parse_index_spec(nil), 'Parse index spec')
    assert_equal(0, @word.parse_index_spec('f'), 'Parse index spec')
  end

  def test_parse_mod_spec
    assert_equal(0, @word.parse_mod_spec('(0:5)'), 'Parse modification spec')
    assert_equal(1, @word.parse_mod_spec('(0:4)'), 'Parse modification spec')
    assert_equal(13, @word.parse_mod_spec('(2:3)'), 'Parse modification spec')
    assert_equal(5, @word.parse_mod_spec('(0:0)'), 'Parse modification spec')
    assert_equal(0, @word.parse_mod_spec('(3:2)'), 'Parse modification spec')
  end

  def test_shift_left
    @word.value = ['+',1,2,3,4,5]
    @word.shift_left
    assert_equal(['+',2,3,4,5,0], @word.value, "Shift left")
  end

  def test_shift_right
    @word.value = ['+',1,2,3,4,5]
    @word.shift_right
    assert_equal(['+',0,1,2,3,4], @word.value, "Shift right")
  end

  def test_rotate_left
    @word.value = ['+',1,2,3,4,5]
    @word.rotate_left
    assert_equal(['+',2,3,4,5,1], @word.value, "Rotate left")
  end

  def test_rotate_right
    @word.value = ['+',1,2,3,4,5]
    @word.rotate_right
    assert_equal(['+',5,1,2,3,4], @word.value, "Rotate right")
  end

 end
