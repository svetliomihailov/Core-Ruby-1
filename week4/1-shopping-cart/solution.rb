require 'bigdecimal'
require 'bigdecimal/util'

module Discounts
  def build_promotion(promo)
    a = promo.shift
    case a[0]
    when :get_one_free then return GetOneFreePromotion.new a[1]
    when :package then return PackagePromotion.new a[1]
    when :threshold then return ThresholdPromotion.new a[1]
    else
      nil
    end
  end

  class GetOneFreePromotion
    def initialize(one_free)
      unless validate_one_free one_free
        fail ArgumentError, 'Must be whole positive number'
      end
      @num = one_free
    end

    def discount(product_count, price)
      free = product_count / @num
      BigDecimal.new free * price
    end

    def to_s
      "(buy #{@num}, get 1 free)"
    end

    private

    def validate_one_free(one_free)
      one_free.is_a?(Numeric) && one_free > 0
    end
  end

  class PackagePromotion
    def initialize(package_promo)
      unless validate_pack_promo package_promo.dup
        fail ArgumentError, 'Wrong argument values'
      end
      @pack_promo = package_promo.shift
    end

    def discount(product_count, price)
      n = product_count / @pack_promo[0]
      disc = BigDecimal.new n * price * @pack_promo[1] * @pack_promo[0]
      disc / 100
    end

    def to_s
      "(get #{@pack_promo[1]}% off for every #{@pack_promo[0]})"
    end

    private

    def validate_pack_promo(pack_promo)
      return false unless pack_promo.instance_of? Hash
      return false unless pack_promo.size == 1
      h = pack_promo.shift
      return true if h[0] > 0 && h[1] > 0 && h[1] < 101
      false
    end
  end

  class ThresholdPromotion
    def initialize(tresh_promo)
      unless validate_tresh_promo tresh_promo.dup
        fail ArgumentError, 'Wrong argument values'
      end
      @tresh_promo = tresh_promo.shift
    end

    def discount(product_count, price)
      return BigDecimal.new '0' if product_count <= @tresh_promo[0]
      disc = (product_count - @tresh_promo[0]) * price * @tresh_promo[1]
      disc / 100
    end

    def to_s
      "(#{@tresh_promo[1]}% off of every after the #{@tresh_promo[0]})"
    end

    private

    def validate_tresh_promo(tresh_promo)
      return false unless tresh_promo.instance_of? Hash
      return false unless tresh_promo.size == 1
      h = tresh_promo.shift
      return true if h[0] > 0 && h[1] > 0 && h[1] < 101
      false
    end
  end

  def build_coupon(name, coupon_arg)
    unless coupon_arg.instance_of?(Hash) && coupon_arg.size == 1
      fail ArgumentError, 'Coupon arguments error'
    end

    a = coupon_arg.shift
    case a[0]
    when :percent then return PercentCoupon.new name, a[1]
    when :amount then return AmountCoupon.new name, a[1]
    else
      fail ArgumentError, 'Unknown type of coupon'
    end
  end

  class PercentCoupon
    attr_reader :name, :percent

    def initialize(name, percent)
      unless validate_percent percent
        fail ArgumentError, 'Wrong value for coupon percent'
      end
      @name = name
      @percent = percent
    end

    def coupon_discount(amount)
      BigDecimal.new amount * @percent / BigDecimal.new(100)
    end

    def to_s
      "Coupon #{@name} - #{@percent}% off"
    end

    private

    def validate_percent(percent)
      if percent > 100 || percent < 0
        false
      else
        true
      end
    end
  end

  class AmountCoupon
    attr_reader :name, :amount

    def initialize(name, amount)
      unless validate_amount amount
        fail ArgumentError, 'Wrong value for coupon amount'
      end
      @name = name
      @amount = amount
    end

    def coupon_discount(amount)
      if @amount >= amount
        BigDecimal.new '0'
      else
        BigDecimal.new @amount
      end
    end

    def to_s
      "Coupon #{@name} - #{@amount} off"
    end

    private

    def validate_amount(amount)
      if amount < 0
        false
      else
        true
      end
    end
  end
end

module Formatter
  def format_sep_line
    "+----------------------------------------------------+------------+\n"
  end

  def format_header
    head = format_sep_line
    head += format_product_line 'Name', 'qty', 'price'
    head += format_sep_line
    head
  end

  def format_footer_with_coupon(coupon_s, total, discount)
    footer = format_coupon_line coupon_s, discount
    footer += format_sep_line
    footer +=
      format_product_line 'TOTAL', '', total - discount
    footer += format_sep_line
    footer
  end

  def format_footer_without_coupon(total)
    footer = format_sep_line
    footer += format_product_line 'TOTAL', '', total
    footer += format_sep_line
    footer
  end

  def format_product_line(name, qty, price)
    if price.instance_of? BigDecimal
      ps = format '%.02f', price
      format "| %-40s%10s | %10s |\n", name, qty.to_s, ps
    else
      format "| %-40s%10s | %10s |\n", name, qty.to_s, price.to_s
    end
  end

  def format_promotion_line(promo_name, discount)
    ps = format '-%.02f', discount
    format "|      %-45s | %10s |\n", promo_name, ps
  end

  def format_coupon_line(coupon_s, discount)
    ps = format '-%.02f', discount
    format "| %-50s | %10s |\n", coupon_s, ps
  end
end

module Store
  class Inventory
    include Discounts

    def initialize
      @products = {}
      @coupons = {}
    end

    def register(name, price, **promos)
      p = Product.new name, price, **promos
      if @products.key? p.name
        fail ArgumentError, 'Product already in the inventory'
      end
      @products.merge! p.name => p
    end

    def each_product
      if block_given?
        @products.each { |_k, v| yield v }
      else
        @products.enum_for(:each_value) { size }
      end
    end

    def each_coupon
      if block_given?
        @coupons.each { |_k, v| yield v }
      else
        @coupons.enum_for(:each_value) { size }
      end
    end

    def register_coupon(name, coupon_arg)
      c = build_coupon name, coupon_arg
      if @coupons.key? c.name
        fail ArgumentError, 'Coupon with that name already ine the inventory'
      end
      @coupons.merge! c.name => c
    end

    def new_cart
      Cart.new self
    end

    def include_product?(name)
      @products.key? name
    end

    def include_coupon?(name)
      @coupons.key? name
    end
  end

  class Cart
    include Formatter

    def initialize(inventory)
      unless inventory.instance_of? Inventory
        fail ArgumentError, 'Inventory object expected'
      end
      @inv = inventory
      @shop_list = {}
    end

    def add(name, count = 1)
      unless @inv.include_product? name
        fail ArgumentError, 'No such product in the inventory'
      end
      @inv.each_product do |pr|
        add_to_cart pr, count if pr.name == name
      end
    end

    def use(name)
      unless @inv.include_coupon? name
        fail ArgumentError, 'No such coupon in the inventry'
      end
      fail ArgumentError, 'Only one coupon per cart' unless @coupon.nil?

      @inv.each_coupon do |c|
        @coupon = c if c.name == name
      end
    end

    def total(with_coupon = true)
      tot = BigDecimal.new '0'
      @shop_list.each_value do
        |i| tot += i.total - i.pr.promo_discount(i.qty)
      end
      unless @coupon.nil? || with_coupon == false
        tot -= @coupon.coupon_discount(tot)
      end
      tot
    end

    def invoice
      invoice = format_header
      @shop_list.each_value do |i|
        invoice += format_product_line i.pr.name, i.qty, i.total
        unless i.pr.promo_discount(i.qty) == BigDecimal.new('0')
          invoice +=
            format_promotion_line i.pr.promo_to_s, i.pr.promo_discount(i.qty)
        end
      end
      invoice += footer
      invoice
    end

    private

    def footer
      if @coupon.nil?
        format_footer_without_coupon total
      else
        i = total false
        format_footer_with_coupon @coupon.to_s, i, @coupon.coupon_discount(i)
      end
    end

    def single_item_total(item)
      BigDecimal.new(item.pr.price) * BigDecimal.new(item.qty)
    end

    def add_to_cart(prd, count)
      if @shop_list.key? prd.name
        add_count_to_item prd.name, count
      else
        create_cart_item prd, count
      end
    end

    def create_cart_item(prd, count)
      if count < 0 || count > 99
        fail ArgumentError, 'Incorrect count of item in the cart'
      end
      @shop_list[prd.name] = CartItem.new prd, count
    end

    def add_count_to_item(name, count)
      c = @shop_list[name].qty + count
      if c < 0 || c > 99
        fail ArgumentError, 'Incorrect count of item in the cart'
      end
      @shop_list[name].qty = c
    end
  end

  class CartItem
    attr_reader :pr
    attr_accessor :qty

    def initialize(product, qty = 1)
      unless product.instance_of? Product
        fail ArgumentError, 'Product type expected'
      end
      @pr = product
      @qty = qty
    end

    def total
      BigDecimal.new(@qty) * @pr.price
    end
  end

  class Product
    include Discounts
    attr_accessor :name, :price
    attr_accessor :promo

    def initialize(name, price, **promos)
      @price = price.to_d if validate_price(price)
      @name = name if validate_name(name)
      @promo = add_promo(**promos)
    end

    def promo_discount(count)
      if @promo.nil?
        0
      else
        @promo.discount count, @price
      end
    end

    def promo_to_s
      @promo.to_s
    end

    private

    def add_promo(**promos)
      if promos.empty?
        nil
      elsif promos.size > 1
        fail ArgumentError, 'Only one promotion allowed'
      else
        build_promotion(promos)
      end
    end

    def validate_name(name)
      if name.length > 40
        fail ArgumentError, 'Product name too long'
      else
        true
      end
    end

    def validate_price(price)
      if price.to_d >= 0.01 && price.to_d <= 999.99
        true
      else
        fail ArgumentError, 'Price out of range'
      end
    end
  end
end
