
require 'test/unit'
load 'computer.rb'
      
 class ComputerTest < Test::Unit::TestCase
  def setup
    @computer = Computer.new
  end
  
  def test_load_device
    @computer.load_device(0, nil)
    assert_equal(:tape, @computer.devices[0].type, "Loading a new device")

    @computer.load_device(6, nil)
    assert_equal(:tape, @computer.devices[6].type, "Loading a new device")

    @computer.load_device(7, nil)
    assert_equal(:disk, @computer.devices[7].type, "Loading a new device")

    @computer.load_device(14, nil)
    assert_equal(:disk, @computer.devices[14].type, "Loading a new device")

    @computer.load_device(15, nil)
    assert_equal(:card_reader, @computer.devices[15].type, "Loading a new device")

    @computer.load_device(16, nil)
    assert_equal(:card_writer, @computer.devices[16].type, "Loading a new device")

    @computer.load_device(17, nil)
    assert_equal(:line_printer, @computer.devices[17].type, "Loading a new device")

    @computer.load_device(18, nil)
    assert_equal(:terminal, @computer.devices[18].type, "Loading a new device")

    @computer.load_device(19, nil)
    assert_equal(:paper_tape, @computer.devices[19].type, "Loading a new device")

    @computer.load_device(22, nil)
    assert_equal(Computer.ERROR, @computer.status, "Loading a new device out of range")
  end
end
