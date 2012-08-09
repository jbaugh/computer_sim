
require 'test/unit'
load 'w_expression.rb'

class WExpressionTest < Test::Unit::TestCase
  def setup
    @computer = Computer.new
    @expression = WExpression.new(@computer, 50, '')
  end

  def test_evaluate
    @expression.expression = '2+3*5'
    assert_equal(25, @expression.evaluate, 'Evaluating a basic expression')

    @expression.expression = '2-3*5'
    assert_equal(-5, @expression.evaluate, 'Evaluating a basic expression')

    @expression.expression = '4/2*3+@'
    @expression.memory_address = 25
    assert_equal(31, @expression.evaluate, 'Evaluating an expression with memory address')
  end
  
end
