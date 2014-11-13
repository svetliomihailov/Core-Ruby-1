require 'minitest/autorun'

require_relative 'solution'

class ProductTest < Minitest::Test
  include Store

  def test_creation
    assert_raises(ArgumentError) { Product.new 'Tea', '1000' }
    assert_raises(ArgumentError) do
      Product.new 'Teaawdwadwasdwasdwasdwasdwawdasdwadasdcwaidaodwad', '1'
    end
    assert_equal true, Product.new('Tea', '2,34').instance_of?(Product)
  end
end

class CartTest < Minitest::Test
  include Store
end
