
require 'test/unit'
load 'device.rb'
      
 class DeviceTest < Test::Unit::TestCase
  def setup
    @computer = Computer.new
    @device = Device.new(@computer, :tape)
  end
  
  def test_reset

  end

 end
