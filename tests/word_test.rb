
require 'test/unit'
load 'word.rb'
load 'computer.rb'
      
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

  def test_from_code
    @word.reset

    @word.from_code('LDA 2000,1(0:5)')
    assert_equal(['+',20,0,1,0,0], @word.value, 'Parse from string')

    @word.from_code('JXNP 3999,3(3:5)')
    assert_equal(['+',39,99,3,15,91], @word.value, 'Parse from string')

    @word.from_code('LDA 21,0(0:5)')
    assert_equal(['+',0,21,0,0,0], @word.value, 'Parse from string')

    @word.from_code('HLT')
    assert_equal(['+',0,0,0,0,136], @word.value, 'Parse from string')

    @word.from_code('JNOV 150,1')
    assert_equal(['+',1,50,1,0,73], @word.value, 'Parse from string')

    @word.from_code('FOO LDA 2000,1(0:5)')
    assert_equal(['+',20,0,1,0,0], @word.value, 'Parse from string')
    assert_equal("FOO", @word.label, 'Parse from string')
  end

  def test_to_code
    @word.value = ['+',20,0,1,0,0]
    assert_equal('LDA 2000,1(0:5)', @word.to_code, 'Word to string')

    @word.value = ['+',20,50,1,3,4]
    assert_equal('LD3 2050,1(0:2)', @word.to_code, 'Word to string')

    @word.value = ['-',39,99,3,15,91]
    assert_equal('JXNP 3999,3(3:5)', @word.to_code, 'Word to string')

    @word.value = ['+',0,0,0,0,136]
    assert_equal('HLT 0,0(0:5)', @word.to_code, 'Word to string')

    @word.value = ['+',1,50,1,0,73]
    assert_equal('JNOV 150,1(0:5)', @word.to_code, 'Word to string')

    @word.value = ['+',20,0,1,0,0]
    @word.label = 'FOO'
    assert_equal('FOO LDA 2000,1(0:5)', @word.to_code, 'Word to string')
  end

  def test_from_string
    @word.from_string('hello')
    assert_equal(['+',34,31,38,38,41], @word.value, 'Testing from string value')

    @word.from_string('foo')
    assert_equal(['+',0,0,32,41,41], @word.value, 'Testing from string value')

    @word.from_string('baRr#')
    assert_equal(['+',28,27,18,44,65], @word.value, 'Testing from string value')

    @word.from_string('A')
    assert_equal(['+',0,0,0,0,1], @word.value, 'Testing from string value')

    @word.from_string('     ')
    assert_equal(['+',0,0,0,0,0], @word.value, 'Testing from string value')

    @word.from_string('I LOVE LUCY')
    assert_equal(['+',9,0,12,15,22], @word.value, 'Only counts the first 5 letters')
  end

  def test_to_string
    @word.value = ['+', 5,17,29,38,51]
    assert_equal('EQcly', @word.to_string, 'Testing word to string')

    @word.value = ['+', 4,44,47,35,30]
    assert_equal('Druid', @word.to_string, 'Testing word to string')

    @word.value = ['+', 81,82,0,1,74]
    assert_equal('?/ A+', @word.to_string, 'Testing word to string')

    @word.value = ['+', 0,0,0,0,74]
    assert_equal('    +', @word.to_string, 'Testing word to string')
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
    val = @word.shift_left
    assert_equal(['+',2,3,4,5,0], @word.value, "Shift left")
    assert_equal(1, val, 'Shifting returns lost byte')
  end

  def test_shift_right
    @word.value = ['+',1,2,3,4,5]
    val = @word.shift_right
    assert_equal(['+',0,1,2,3,4], @word.value, "Shift right")
    assert_equal(5, val, 'Shifting returns lost byte')
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
