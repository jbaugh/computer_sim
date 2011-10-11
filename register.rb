
load 'word.rb'

class Register
  attr_accessor :word
  attr_reader :size

  def initialize(size)
    @size = size
    self.reset
  end

  def value
    @word.value
  end

  def value=(val)
    @word.value = val
  end

  def reset
    @word = Word.new(@size)
  end

  def overflowed?
    @word.overflowed?
  end

  def positive?
    val = @word.to_i
    val > 0
  end

  def zero?
    val = @word.to_i
    val == 0
  end

  def negative?
    val = @word.to_i
    val < 0
  end
end