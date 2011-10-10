
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

  def greater_than?
    val = @word.to_i
    val > 0
  end

  def equal_to?
    val = @word.to_i
    val == 0
  end

  def less_than?
    val = @word.to_i
    val < 0
  end
end