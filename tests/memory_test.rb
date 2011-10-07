require 'test/unit'
load 'computer.rb'

class MemoryTest < Test::Unit::TestCase
  def setup
    @computer = Computer.new
  end

  def test_read
    @computer.memory.storage[0].value = ['+',6,1,2,3,4]
    assert_equal(['+',6,1,2,3,4], @computer.memory.read(0, 0, 5).value, 'Reading whole memory')

    @computer.memory.storage[0].value = ['+',6,1,2,3,4]
    assert_equal(['+',0,0,2,3,4], @computer.memory.read(0, 3, 5).value, 'Reading partial memory')

    @computer.memory.storage[0].value = ['+',6,1,2,3,4]
    assert_equal(['+',6,1,0,0,0], @computer.memory.read(0, 0, 2).value, 'Reading partial memory')

    @computer.memory.storage[0].value = ['-',6,1,2,3,4]
    assert_equal(['+',0,1,2,3,0], @computer.memory.read(0, 2, 4).value, 'Reading partial memory')

    @computer.memory.storage[0].value = ['-',6,1,2,3,4]
    assert_equal(['+',6,0,0,0,0], @computer.memory.read(0, 1, 1).value, 'Reading partial memory')

    @computer.memory.storage[0].value = ['-',6,1,2,3,4]
    assert_equal(Word.default(5), @computer.memory.read(0, 3, 1).value, 'Left larger than right on read')
  end

  def test_write
    @computer.memory.write(0, ['+',0,1,2,3,4], 0, 5)
    assert_equal(['+',0,1,2,3,4], @computer.memory.storage[0].value, 'Writing memory failed')

    @computer.memory.write(0, ['+',4,5,6,3,4], 0, 3)
    assert_equal(['+',4,5,6,3,4], @computer.memory.storage[0].value, 'Writing memory failed')

    @computer.memory.write(0, ['+',3,4,7,9,1], 3, 5)
    assert_equal(['+',4,5,7,9,1], @computer.memory.storage[0].value, 'Writing memory failed')

    @computer.memory.write(0, ['+',0,1,2,3,4], 5, 5)
    assert_equal(['+',4,5,7,9,4], @computer.memory.storage[0].value, 'Writing memory failed')

    @computer.memory.write(0, ['-',0,1,2,3,4], 0, 0)
    assert_equal(['-',4,5,7,9,4], @computer.memory.storage[0].value, 'Writing memory failed')

    @computer.memory.write(0, [3,0,1,2,3,4], 0, 0)
    assert_equal(['+',4,5,7,9,4], @computer.memory.storage[0].value, 'Writing memory failed')

    @computer.memory.write(0, [3,9,4,3,2,9], 3, 0)
    assert_equal(['+',4,5,7,9,4], @computer.memory.storage[0].value, 'Writing memory failed')
  end

  def test_reset
    @computer.memory.storage[0].value = ['+',0,1,2,3,4]
    @computer.memory.reset
    assert_equal(Word.default(5), @computer.memory.storage[0].value, 'Reset all memory')

    @computer.memory.storage[0].value = ['+',0,1,2,3,4]
    @computer.memory.reset(0)
    assert_equal(Word.default(5), @computer.memory.storage[0].value, 'Reset specific memory')

    @computer.memory.storage[0].value = ['+',0,1,2,3,4]
    @computer.memory.reset(1)
    assert_equal(['+',0,1,2,3,4], @computer.memory.storage[0].value, 'Reset specific memory')
  end

  def test_within_storage_limits?
    assert_equal(false, @computer.memory.within_storage_limits?(-10), "Testing storage limits")

    assert_equal(false, @computer.memory.within_storage_limits?(@computer.memory.storage_amount + 100), "Testing storage limits")

    assert_equal(false, @computer.memory.within_storage_limits?(@computer.memory.storage_amount), "Testing storage limits")

    assert_equal(true, @computer.memory.within_storage_limits?(0), "Testing storage limits")

    assert_equal(true, @computer.memory.within_storage_limits?(@computer.memory.storage_amount - 1), "Testing storage limits")
  end
end
