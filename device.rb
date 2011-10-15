
load 'memory.rb'

class Device
  attr_reader :memory, :type, :io_type, :word_pointer

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
    when :empty
      @io_type = nil
      num_of_words = 0
    end

    @busy = false
    @word_pointer = 0
    @memory = Memory.new(@computer, num_of_words)
  end

  # Move word pointer by some amount
  def move_word_pointer(amount)
    if amount == 0
      @word_pointer = 0
    else
      @word_pointer += amount
      ensure_word_pointer_in_range
    end
  end

  # Reads a single word from memory at word_pointer
  def read
    @busy = true
    block = memory.read(@word_pointer)
    @word_pointer += 1
    ensure_word_pointer_in_range
    @busy = false

    block
  end

  # Writes a single word to memory at word_pointer
  def write(word)
    @busy = true
    memory.write(@word_pointer, word)
    @word_pointer += 1
    ensure_word_pointer_in_range
    @busy = false
  end

  def busy?
    @busy
  end

  def ready?
    !busy?
  end

  def empty?
    @type == :empty
  end

  def can?(io)
    (io & @io_type) > 0
  end

  def ensure_word_pointer_in_range
    @word_pointer %= memory.storage_amount
  end

  def self.bin_in;   1; end   # 0001
  def self.bin_out;  2; end   # 0010
  def self.char_in;  4; end   # 0100
  def self.char_out; 8; end   # 1000
end
