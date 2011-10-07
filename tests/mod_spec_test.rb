
require 'test/unit'
load 'mod_spec.rb'

class ModSpecTest < Test::Unit::TestCase
  
  def test_get_byte
    assert_equal(0, ModSpec.get_byte({:l => 0, :r => 5}), 'Get byte')
    assert_equal(18, ModSpec.get_byte({:l => 4, :r => 5}), 'Get byte')
    assert_equal(0, ModSpec.get_byte({:l => 5, :r => 3}), 'Get byte with invalid spec returns 0')
    assert_equal(0, ModSpec.get_byte(12), 'Get byte with invalid data returns 0')
  end

  def test_get_command
    assert_equal({:l => 0, :r => 5}, ModSpec.get_command(0), 'Get command')
    assert_equal({:l => 0, :r => 5}, ModSpec.get_command(-91289), 'Get command with invalid byte')
    assert_equal({:l => 5, :r => 5}, ModSpec.get_command(20), 'Get command')
    assert_equal({:l => 2, :r => 4}, ModSpec.get_command(12), 'Get command')
    assert_equal({:l => 1, :r => 5}, ModSpec.get_command(6), 'Get command')

  end

  def test_lossless_gets
    assert_equal({:l => 0, :r => 5}, ModSpec.get_command(ModSpec.get_byte({:l => 0, :r => 5})), 'Lossless gets')
    assert_equal({:l => 1, :r => 5}, ModSpec.get_command(ModSpec.get_byte({:l => 1, :r => 5})), 'Lossless gets')
    assert_equal({:l => 3, :r => 4}, ModSpec.get_command(ModSpec.get_byte({:l => 3, :r => 4})), 'Lossless gets')
    assert_equal({:l => 0, :r => 1}, ModSpec.get_command(ModSpec.get_byte({:l => 0, :r => 1})), 'Lossless gets')
    assert_equal({:l => 3, :r => 3}, ModSpec.get_command(ModSpec.get_byte({:l => 3, :r => 3})), 'Lossless gets')
  end 
end
