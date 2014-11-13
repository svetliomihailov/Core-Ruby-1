require 'bigdecimal'
require 'bigdecimal/util'

module Store
  class Inventory
    def register
    end

    def register_coupon
    end

    def new_cart
    end
  end

  class Product
    attr_reader :name, :price

    def initialize(name, price)
      fail ArgumentError, 'Product name too long' if name.length > 40
      @name = name
      @price = price.to_d
      fail ArgumentError, \
           'Price out of range' unless @price >= 0.01 && @price <= 999.99
    end
  end

  class Cart
    def add
    end

    def use
    end

    def total
    end

    def invoice
    end
  end
end
