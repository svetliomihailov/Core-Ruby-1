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
      disc = BigDecimal.new n * price * @pack_promo[1]
      disc / 100
    end

    private

    def validate_pack_promo(pack_promo)
      return false unless pack_promo.instance_of? Hash
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
      disc = (product_count - @tresh_promo[0]) * price * @tresh_promo[1]
      disc / 100
    end

    private

    def validate_tresh_promo(tresh_promo)
      return false unless tresh_promo.instance_of? Hash
      h = tresh_promo.shift
      return true if h[0] > 0 && h[1] > 0 && h[1] < 101
      false
    end
  end

  def build_coupon
  end

  class PercentCoupon
  end

  class AmountCoupon
  end
end

module Store
  class Inventory
    def initialize
      @products = {}
    end

    def register(name, price)
      p = Product.new name, price
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

    def register_coupon
    end

    def new_cart
      Cart.new self
    end

    def include?(name)
      @products.key? name
    end
  end

  class Cart
    def initialize(inventory)
      unless inventory.instance_of? Inventory
        fail ArgumentError, 'Inventory object expected'
      end
      @inv = inventory
      @shop_list = {}
    end

    def add(name, count = 1)
      unless @inv.include? name
        fail ArgumentError, 'No such product in the inventory'
      end
      @inv.each_product do |pr|
        add_to_cart pr, count if pr.name == name
      end
    end

    def use
    end

    def total
      total = BigDecimal.new '0'
      @shop_list.each_value { |i| total += i.total }
      total
    end

    def invoice
      invoice = format_sep_line
      invoice += format_product_line 'Name', 'qty', 'price'
      invoice += format_sep_line
      @shop_list.each_value do |i|
        invoice += format_product_line i.pr.name, i.qty, i.total
      end
      invoice += format_sep_line
      invoice += format_product_line 'TOTAL', '', total
      invoice += format_sep_line
      invoice
    end

    private

    def format_sep_line
      "+----------------------------------------------------+------------+\n"
    end

    def format_product_line(name, qty, price)
      if price.instance_of? BigDecimal
        ps = format '%.02f', price
        format "| %-40s%10s | %10s |\n", name, qty.to_s, ps
      else
        format "| %-40s%10s | %10s |\n", name, qty.to_s, price.to_s
      end
    end

    def format_promotion_line
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
