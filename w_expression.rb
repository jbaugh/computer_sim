
class WExpression
  attr_accessor :expression, :memory_address

  def initialize(computer, memory_address, expression)
    @computer = computer
    @memory_address = memory_address
    @expression = expression
  end

  # WEXP = EXP[(EXP)][,WEXP]
  def evaluate
    temp_exp = @expression.gsub('@', @memory_address.to_s)
    
    evaluate_expression(temp_exp)
  end

private 

  def evaluate_expression(exp)
    exp = replace_variable_values(exp)
    chunks = exp.split(/(\+|\*|-|\/)/)
    i = 2
    val = chunks[0]
    while i < chunks.size
      val = eval("#{val} #{chunks[i - 1]} #{chunks[i]}")
      i += 2
    end
    val
  end

  def replace_variable_values(exp)
    
  end
end
