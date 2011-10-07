
load 'cpu.rb'
load 'memory.rb'

class Computer
  def self.OK; :ok; end
  def self.ERROR; :error; end
  def self.IO_WAIT; :io_wait; end
  def self.HALT; :halt; end

  attr_accessor :status, :message
  attr_accessor :cpu, :memory

  def initialize
    @cpu = CPU.new(self)
    @memory = Memory.new(self, 4000)

    @status = Computer.OK
    @message = "@"
  end

  def reset
    @cpu.reset
    @memory.reset
  end
end