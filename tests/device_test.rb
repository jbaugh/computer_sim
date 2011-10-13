
require 'test/unit'
load 'device.rb'
      
 class DeviceTest < Test::Unit::TestCase
  def setup
    @computer = Computer.new
  end
  
  def test_initialize
    @dev = Device.new(@computer, :tape)
    assert_equal(100, @dev.memory.storage_amount, "Tape device initialization")
    assert_equal(Device.bin_in | Device.bin_out, @dev.io_type, "Tape device initialization")

    @dev = Device.new(@computer, :disk)
    assert_equal(100, @dev.memory.storage_amount, "Disk device initialization")
    assert_equal(Device.bin_in | Device.bin_out, @dev.io_type, "Disk device initialization")

    @dev = Device.new(@computer, :card_reader)
    assert_equal(16, @dev.memory.storage_amount, "Card reader device initialization")
    assert_equal(Device.char_in, @dev.io_type, "Card reader device initialization")

    @dev = Device.new(@computer, :card_writer)
    assert_equal(16, @dev.memory.storage_amount, "Card writer device initialization")
    assert_equal(Device.char_out, @dev.io_type, "Card writer device initialization")

    @dev = Device.new(@computer, :line_printer)
    assert_equal(24, @dev.memory.storage_amount, "Line printer device initialization")
    assert_equal(Device.char_out, @dev.io_type, "Line printer device initialization")

    @dev = Device.new(@computer, :terminal)
    assert_equal(14, @dev.memory.storage_amount, "Terminal device initialization")
    assert_equal(Device.char_in | Device.char_out, @dev.io_type, "Terminal device initialization")

    @dev = Device.new(@computer, :paper_tape)
    assert_equal(14, @dev.memory.storage_amount, "Paper tape device initialization")
    assert_equal(Device.char_in, @dev.io_type, "Paper tape device initialization")
  end

  def test_can?
    @dev = Device.new(@computer, :tape)
    assert_equal(true, @dev.can?(Device.bin_in), "Device io capabilities")
    assert_equal(true, @dev.can?(Device.bin_out), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.char_in), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.char_out), "Device io capabilities")

    @dev = Device.new(@computer, :disk)
    assert_equal(true, @dev.can?(Device.bin_in), "Device io capabilities")
    assert_equal(true, @dev.can?(Device.bin_out), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.char_in), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.char_out), "Device io capabilities")

    @dev = Device.new(@computer, :card_reader)
    assert_equal(false, @dev.can?(Device.bin_in), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.bin_out), "Device io capabilities")
    assert_equal(true, @dev.can?(Device.char_in), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.char_out), "Device io capabilities")

    @dev = Device.new(@computer, :card_writer)
    assert_equal(false, @dev.can?(Device.bin_in), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.bin_out), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.char_in), "Device io capabilities")
    assert_equal(true, @dev.can?(Device.char_out), "Device io capabilities")

    @dev = Device.new(@computer, :line_printer)
    assert_equal(false, @dev.can?(Device.bin_in), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.bin_out), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.char_in), "Device io capabilities")
    assert_equal(true, @dev.can?(Device.char_out), "Device io capabilities")

    @dev = Device.new(@computer, :terminal)
    assert_equal(false, @dev.can?(Device.bin_in), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.bin_out), "Device io capabilities")
    assert_equal(true, @dev.can?(Device.char_in), "Device io capabilities")
    assert_equal(true, @dev.can?(Device.char_out), "Device io capabilities")

    @dev = Device.new(@computer, :paper_tape)
    assert_equal(false, @dev.can?(Device.bin_in), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.bin_out), "Device io capabilities")
    assert_equal(true, @dev.can?(Device.char_in), "Device io capabilities")
    assert_equal(false, @dev.can?(Device.char_out), "Device io capabilities")
  end

end
