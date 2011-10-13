
load 'memory.rb'

class Device
  attr_reader :memory
  attr_reader :type, :io_type

  def initialize(computer, type)
    @computer = computer
    @type = type
    reset
  end

  def reset
    case @type
    when :tape
      @io_type = Device.bin_in | Device.bin_out
      num_of_words = 100
    when :disk
      @io_type = Device.bin_in | Device.bin_out
      num_of_words = 100
    when :card_reader
      @io_type = Device.char_in
      num_of_words = 16
    when :card_writer
      @io_type = Device.char_out
      num_of_words = 16
    when :line_printer
      @io_type = Device.char_out
      num_of_words = 24
    when :terminal
      @io_type = Device.char_in | Device.char_out
      num_of_words = 14
    when :paper_tape
      @io_type = Device.char_in
      num_of_words = 14
    end

    @memory = Memory.new(@computer, num_of_words)
  end

  def can?(io)
     (io & @io_type) > 0
  end

  def self.bin_in;   1; end   # 0001
  def self.bin_out;  2; end   # 0010
  def self.char_in;  4; end   # 0100
  def self.char_out; 8; end   # 1000
end