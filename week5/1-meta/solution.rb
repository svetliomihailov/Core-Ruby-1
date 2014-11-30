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
  def private_attr_accessor(*args)
    private_attr_reader(*args)
    private_attr_writer(*args)
  end

  def private_attr_reader(*args)
    args.each do |arg|
      define_method(arg) { instance_variable_get('@' + arg.to_s) }
      class_eval { private arg.to_sym }
    end
  end

  def private_attr_writer(*args)
    args.each do |arg|
      met = arg.to_s + '='
      define_method(met) do |val|
        instance_variable_set('@' + arg.to_s, val)
      end
      class_eval { private met.to_sym }
    end
  end

  def cattr_accessor(*args, &block)
    cattr_writer(*args, &block)
    cattr_reader(*args)
  end

  def cattr_reader(*args)
    args.each do |arg|
      define_singleton_method(arg) { class_variable_get('@@' + arg.to_s) }
    end
  end

  def cattr_writer(*args, &block)
    args.each do |arg|
      define_singleton_method(arg.to_s + '=') do |val|
        class_variable_set('@@' + arg.to_s, val)
      end
      send(arg.to_s + '=', block.call) if block_given?
    end
  end
end

class NilClass
  def method_missing(symbol, *args)
    nil
  end

  def respond_to_missing?(symbol, include_all)
    super
  end
end
