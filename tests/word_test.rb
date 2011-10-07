
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

 end
