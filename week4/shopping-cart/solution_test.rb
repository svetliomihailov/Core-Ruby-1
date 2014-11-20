require 'minitest/autorun'

require_relative 'solution'

class ProductTest < Minitest::Test
  include Store
  include Discounts

  def test_creation
    assert_raises(ArgumentError) { Product.new 'Tea', '1000' }
    assert_raises(ArgumentError) do
      Product.new 'Teaawdwadwasdwasdwasdwasdwawdasdwadasdcwaidaodwad', '1'
    end
    assert_equal true, Product.new('Tea', '2,34').instance_of?(Product)
  end

  def test_promotion
    assert_raises(ArgumentError) do
      Product.new 'Tea', '1', package: { 3 => 70 }, get_one_free: 6
    end

    p1 = Product.new 'Tea', '1', package: { 3 => 20 }
    assert_equal true, p1.promo.instance_of?(PackagePromotion)

    p1 = Product.new 'Tea', '1', get_one_free: 4
    assert_equal true, p1.promo.instance_of?(GetOneFreePromotion)

    p1 = Product.new 'Tea', '1', threshold: { 10 => 50 }
    assert_equal true, p1.promo.instance_of?(ThresholdPromotion)
  end
end

class DiscountsTest < Minitest::Test
  include Discounts

  def test_build_promotion
    promo = build_promotion get_one_free: 4
    assert_equal true, promo.instance_of?(GetOneFreePromotion)

    promo = build_promotion(package: { 3 => 20 })
    assert_equal true, promo.instance_of?(PackagePromotion)

    promo = build_promotion(threshold: { 10 => 50 })
    assert_equal true, promo.instance_of?(ThresholdPromotion)
  end

  def test_get_one_free_promo_creation
    assert_raises(ArgumentError) { GetOneFreePromotion.new(-1) }
    assert_raises(ArgumentError) { GetOneFreePromotion.new 'bla' }
    promo = GetOneFreePromotion.new 6
    assert_equal true, promo.instance_of?(GetOneFreePromotion)
  end

  def test_one_free_promo_discount
    promo = GetOneFreePromotion.new 6
    discount = promo.discount 14, BigDecimal('1')
    assert_equal BigDecimal('2'), discount
  end

  def test_package_promo_creation
    assert_raises(ArgumentError) { PackagePromotion.new(-1 => 20) }
    assert_raises(ArgumentError) { PackagePromotion.new 2 => -2 }
    assert_raises(ArgumentError) { PackagePromotion.new 2 => 120 }
    assert_raises(ArgumentError) { PackagePromotion.new 'bla' }
    promo = PackagePromotion.new 3 => 20
    assert_equal true, promo.instance_of?(PackagePromotion)
  end

  def test_package_promo_discount
    promo = PackagePromotion.new 2 => 50
    discount = promo.discount 5, BigDecimal('2')
    assert_equal BigDecimal('2'), discount
  end

  def test_threshold_promo_creation
    assert_raises(ArgumentError) { ThresholdPromotion.new(-1 => 20) }
    assert_raises(ArgumentError) { ThresholdPromotion.new 2 => -2 }
    assert_raises(ArgumentError) { ThresholdPromotion.new 2 => 120 }
    assert_raises(ArgumentError) { ThresholdPromotion.new 'bla' }
    promo = ThresholdPromotion.new 3 => 20
    assert_equal true, promo.instance_of?(ThresholdPromotion)
  end

  def test_threshold_promo_discount
    promo = ThresholdPromotion.new 10 => 50
    discount = promo.discount 20, BigDecimal('1')
    assert_equal BigDecimal('5'), discount
  end
end

class InventoryTest < Minitest::Test
  include Store

  def new_inventory
    inventory = Inventory.new
    inventory.register 'Green Tea', '1.99'
    inventory.register 'Red Tea',   '2.49'
    inventory.register 'Earl Grey', '1.49'
    inventory
  end

  def test_register
    inventory = Inventory.new
    inventory.register 'Earl Grey', '1.49'
    assert_raises(ArgumentError) { inventory.register 'Earl Grey', '1.49' }
  end

  def test_each_product
    inventory = Inventory.new
    inventory.register 'Earl Grey', '1.49'
    inventory.register 'Green Tea', '1.49'

    inventory.each_product { |pr| assert_equal true, pr.instance_of?(Product) }
    enum = inventory.each_product
    assert_equal true, enum.instance_of?(Enumerator)
    enum.each { |e| assert_equal true, e.instance_of?(Product) }
  end

  def test_include?
    inv = new_inventory
    assert_equal true, inv.include?('Earl Grey')
    assert_equal false, inv.include?('Earl Tea')
  end
end

class CartTest < Minitest::Test
  include Store

  def new_inventory
    inventory = Inventory.new
    inventory.register 'Green Tea', '1.99'
    inventory.register 'Red Tea',   '2.49'
    inventory.register 'Earl Grey', '1.49'
    inventory
  end

  def test_creation
    cart = new_inventory.new_cart
    assert_equal true, cart.instance_of?(Cart)
  end

  def test_add
    cart = new_inventory.new_cart
    assert_raises(ArgumentError) { cart.add 'Green Tea', -1 }
    assert_raises(ArgumentError) do
      cart.add 'Green Tea', 99
      cart.add 'Green Tea'
    end
    assert_raises(ArgumentError) { cart.add 'Green Teaaaa', 2 }
  end

  def test_total
    cart = new_inventory.new_cart
    cart.add 'Green Tea', 10
    assert_equal BigDecimal('19.9'), cart.total
  end

  def test_invoice_print
    cart = new_inventory.new_cart
    cart.add 'Green Tea', 10
    cart.add 'Earl Grey', 25
    cart.add 'Red Tea', 42
    puts "\n\n\n"
    puts cart.invoice
    puts "\n\n\n"
  end
end
