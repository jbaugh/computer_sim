
load 'word.rb'

class Memory
  attr_accessor :storage_amount, :storage

  def initialize(computer, storage_amount)
    @computer = computer
    @storage_amount = storage_amount

    self.reset
  end

  # Resets all memory or a specific address
  def reset(location = nil)
    if location.nil?
      @storage = Array.new
      @storage_amount.times do |i|
        @storage.push(Word.new(5))
      end
    else
      if within_storage_limits? location
        @storage[location].reset
      end
    end
  end

  # Reads a word of memory and returns a new Word
  def read(location, left=0, right=5)
    return unless within_storage_limits? location

    ret = Word.new(5)
    right.downto(left) { |i|
      ret.value[i] = @storage[location].value[i]
    }
    ret
  end

  # Writes a Word to a specific memory address
  # left/right values determine what portion of 
  #   the word should be written
  def write(location, mem, left=0, right=5)
    return unless within_storage_limits? location

    right.downto(left) { |i|      
      if i > 0
        @storage[location].value[i] = mem[i]
      end

      if i == 0
        if mem[0] == '+' || mem[0] == '-'
          @storage[location].value[0] = mem[0]
        else
          @storage[location].value[0] = '+'
        end
      end
    }
  end

  # Helper method for determining if the location is in address space
  def within_storage_limits?(location)
    return true if location >= 0 && location < @storage_amount
    @computer.message = "Memory location out of bounds (#{location})."
    @computer.status = Computer.ERROR
    false
  end
end
