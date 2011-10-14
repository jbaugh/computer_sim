
load 'cpu.rb'
load 'memory.rb'
load 'device.rb'

class Computer
  def self.OK; :ok; end
  def self.ERROR; :error; end
  def self.IO_WAIT; :io_wait; end
  def self.HALT; :halt; end

  attr_accessor :status, :message
  attr_accessor :cpu, :memory, :devices

  def initialize
    @cpu = CPU.new(self)
    @memory = Memory.new(self, 4000)
    reset
  end

  def reset
    @status = Computer.OK
    @message = "@"

    @cpu.reset
    @memory.reset

    @devices = Array.new
    20.times do |i|
      @devices.push(Device.new(self, :empty))
    end
  end

  def load_device(slot, code)
    if slot >= 0 && slot < 7
      type = :tape
    elsif slot >= 7 && slot < 15
      type = :disk
    elsif slot == 15
      type = :card_reader
    elsif slot == 16
      type = :card_writer
    elsif slot == 17
      type = :line_printer
    elsif slot == 18
      type = :terminal
    elsif slot == 19
      type = :paper_tape
    else
      raise "No device for this slot"
    end

    @devices[slot] = Device.new(self, type)
  rescue
    @status = Computer.ERROR
    @message = "Coult not load device #{slot}"
  end

  def get_device(slot)
    if slot < 0 || slot > 19
      raise raise "No device for this slot"
    end
    
    return @devices[slot]
  rescue
    @status = Computer.ERROR
    @message = "Coult not get device #{slot}"
  end

  def remove_device(slot)
    if slot < 0 || slot > 19
      raise raise "No device for this slot"
    end
    
    @devices[slot] = Device.new(self, :empty)
  rescue
    @status = Computer.ERROR
    @message = "Coult not remove device #{slot}"
  end
end