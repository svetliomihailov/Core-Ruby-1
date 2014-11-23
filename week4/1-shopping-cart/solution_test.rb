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

    promo = GetOneFreePromotion.new 4
    discount = promo.discount 22, BigDecimal('1')
    assert_equal BigDecimal('5'), discount

    discount = promo.discount 2, BigDecimal('1')
    assert_equal BigDecimal('0'), discount
  end

  def test_package_promo_creation
    assert_raises(ArgumentError) { PackagePromotion.new(-1 => 20) }
    assert_raises(ArgumentError) { PackagePromotion.new 2 => -2 }
    assert_raises(ArgumentError) { PackagePromotion.new 2 => 120 }
    assert_raises(ArgumentError) { PackagePromotion.new 'bla' }
    assert_raises(ArgumentError) { PackagePromotion.new 3 => 20, 2 => 20 }
    promo = PackagePromotion.new 3 => 20
    assert_equal true, promo.instance_of?(PackagePromotion)
  end

  def test_package_promo_discount
    promo = PackagePromotion.new 2 => 50
    discount = promo.discount 5, BigDecimal('2')
    assert_equal BigDecimal('4'), discount

    promo = PackagePromotion.new 3 => 20
    discount = promo.discount 4, BigDecimal('1')
    assert_equal BigDecimal('0.60'), discount

    discount = promo.discount 2, BigDecimal('1')
    assert_equal BigDecimal('0'), discount
  end

  def test_threshold_promo_creation
    assert_raises(ArgumentError) { ThresholdPromotion.new(-1 => 20) }
    assert_raises(ArgumentError) { ThresholdPromotion.new 2 => -2 }
    assert_raises(ArgumentError) { ThresholdPromotion.new 2 => 120 }
    assert_raises(ArgumentError) { ThresholdPromotion.new 'bla' }
    assert_raises(ArgumentError) { ThresholdPromotion.new 3 => 20, 2 => 20 }
    promo = ThresholdPromotion.new 3 => 20
    assert_equal true, promo.instance_of?(ThresholdPromotion)
  end

  def test_threshold_promo_discount
    promo = ThresholdPromotion.new 10 => 50
    discount = promo.discount 20, BigDecimal('1')
    assert_equal BigDecimal('5'), discount
    discount = promo.discount 9, BigDecimal('1')
    assert_equal BigDecimal('0'), discount
  end

  def test_build_coupon
    coup = build_coupon 'TeaTime', percent: 20
    assert_equal true, coup.instance_of?(PercentCoupon)

    coup = build_coupon 'TeaTime2', amount: 45
    assert_equal true, coup.instance_of?(AmountCoupon)

    assert_raises(ArgumentError) { build_coupon 'TeaTime2', freestuff: 45 }
    assert_raises(ArgumentError) do
      build_coupon 'TeaTime2', amount: 45, percent: 20
    end
  end

  def test_percent_coupon_creation
    assert_raises(ArgumentError) { PercentCoupon.new('bla', -1) }
    assert_raises(ArgumentError) { PercentCoupon.new 'bla', 120 }
    coup = PercentCoupon.new 'bla', 80
    assert_equal true, coup.instance_of?(PercentCoupon)
  end

  def test_amount_coupon_creation
    assert_raises(ArgumentError) { AmountCoupon.new('bla', -1) }
    coup = AmountCoupon.new 'bla', 80
    assert_equal true, coup.instance_of?(AmountCoupon)
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

  def test_coupon_register
    inventory = Inventory.new
    inventory.register_coupon 'TEATIME', amount: 20
    assert_raises(ArgumentError) do
      inventory.register_coupon 'TEATIME', amount: 20
    end
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

  def test_include_product?
    inv = new_inventory
    assert_equal true, inv.include_product?('Earl Grey')
    assert_equal false, inv.include_product?('Earl Tea')
  end

  def test_include_coupon
    inv = new_inventory
    inv.register_coupon 'Tea time', amount: 50
    inv.register_coupon 'Breakfast', percent: 50
    assert_equal true, inv.include_coupon?('Tea time')
    assert_equal true, inv.include_coupon?('Breakfast')
    assert_equal false, inv.include_coupon?('Earl Tea')
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
    inv = new_inventory
    cart = inv.new_cart

    cart.add 'Green Tea', 10
    assert_equal BigDecimal('19.9'), cart.total
    inv.register 'Bullshit', 1, get_one_free: 4
    cart.add 'Bullshit', 10
    assert_equal BigDecimal('27.9'), cart.total
  end

  def new_full_invetory
    inventory = Inventory.new
    inventory.register 'Green Tea',    '2.79', get_one_free: 2
    inventory.register 'Black Coffee', '2.99', package: { 2 => 20 }
    inventory.register 'Milk',         '1.79', threshold: { 3 => 30 }
    inventory.register 'Cereal',       '2.49'
    inventory.register_coupon 'BREAKFAST', percent: 10
    inventory
  end

  def test_invoice_from_site
    inv = new_full_invetory
    cart = inv.new_cart
    cart.add 'Green Tea', 8
    cart.add 'Black Coffee', 5
    cart.add 'Milk', 5
    cart.add 'Cereal', 3
    cart.use 'BREAKFAST'

    puts "\n\n"
    puts cart.invoice
    puts "\n\n"
  end
end
