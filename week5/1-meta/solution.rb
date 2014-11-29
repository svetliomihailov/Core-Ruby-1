class Object
  def singleton_class
    case self
    when Numeric then fail TypeError, 'can\'t define singleton'
    when Symbol then fail TypeError, 'can\'t define singleton'
    else
      class << self; self end
    end
  end

  def define_singleton_method(name, method = nil, &block)
    if method.nil?
      singleton_class.send(:define_method, name, &block)
    else
      singleton_class.send(:define_method, name, method)
    end
  end
end

class String
  def to_proc
    methods = to_s.split '.'
    if methods.length > 1
      chained_to_proc methods
    else
      ->(o, *args) { o.send methods[0], *args }
    end
  end

  private

  def chained_to_proc(methods)
    lambda do |o, *args|
      res = o
      methods.each { |method| res = res.send method, *args }
      res
    end
  end
end

class Module
  def private_attr_accessor(arg)
    define_method(arg) { instance_variable_get('@' + arg.to_s) }
    define_method(arg.to_s + '=') do |val|
      instance_variable_set('@' + arg.to_s, val)
    end
  end
end
