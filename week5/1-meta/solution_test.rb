require 'minitest/autorun'

require_relative 'solution'

class Object
  def heil
    puts 'hello from Object'
  end
end

class TestClass
  private_attr_accessor :accessor, :accessor_2
  private_attr_reader :reader
  private_attr_writer :writer

  cattr_reader :cvar
  cattr_writer :cvar
  cattr_accessor :caccessor
  cattr_accessor(:cdefault) { [1, 2, 3] }
end

User = Struct.new(:first_name, :last_name)

class Invoce
  delegate :first_name, :last_name, to: '@user'

  def initialize(user)
    @user = user
  end
end

class SolutionTest < Minitest::Test
  def test_singleton_class_wrong_args
    assert_raises(TypeError) { 1.singleton_class }
    assert_raises(TypeError) { 1.2.singleton_class }
    assert_raises(TypeError) { :bla.singleton_class }
  end

  def test_singleton_class_correct_args
    assert_equal NilClass, nil.singleton_class
    assert_equal FalseClass, false.singleton_class
    assert_equal TrueClass, true.singleton_class
  end

  def test_define_singleton_method
    a = Object.new
    assert_equal false, a.respond_to?(:hello)
    a.define_singleton_method(:hello) { puts 'hello from method hello' }
    assert_equal true, a.respond_to?(:hello)
    assert_raises(NoMethodError) { Object.new.hello }
  end

  def test_define_singleton_method_with_method
    a = Object.new
    m = Object.new.method(:heil)
    assert_equal false, a.respond_to?(:hello)
    a.define_singleton_method(:hello, m)
    assert_equal true, a.respond_to?(:hello)
    assert_raises(NoMethodError) { Object.new.hello }
  end

  def test_string_to_proc
    assert_equal [3, 4, 5, 6], [2, 3, 4, 5].map(&'succ')
    assert_equal [4, 5, 6, 7], [2, 3, 4, 5].map(&'succ.succ')
    assert_equal [3, 4, 5, 6], [2, 3, 4, 5].map(&'succ.succ.pred')
    assert_equal %w(3 4 5 6), [2, 3, 4, 5].map(&'succ.succ.pred.to_s')
  end

  def test_module_private_accessors
    b = TestClass.new
    assert_equal true, b.private_methods.include?(:accessor)
    assert_equal true, b.private_methods.include?(:accessor=)

    assert_equal true, b.private_methods.include?(:accessor_2)
    assert_equal true, b.private_methods.include?(:accessor_2=)

    assert_equal true, b.private_methods.include?(:reader)
    assert_equal false, b.private_methods.include?(:reader=)

    assert_equal true, b.private_methods.include?(:writer=)
    assert_equal false, b.private_methods.include?(:writer)
  end

  def test_module_cattr_accessors
    assert_equal false, TestClass.new.methods.include?(:caccessor)
    assert_equal false, TestClass.new.methods.include?(:caccessor=)
    assert_equal true, TestClass.public_methods.include?(:caccessor)
    assert_equal true, TestClass.public_methods.include?(:caccessor=)
    assert_equal true, TestClass.public_methods.include?(:cvar)
    assert_equal true, TestClass.public_methods.include?(:cvar=)
    assert_equal true, TestClass.public_methods.include?(:cdefault=)
    assert_equal true, TestClass.public_methods.include?(:cdefault)
    assert_equal [1, 2, 3], TestClass.cdefault
  end

  def test_blackhole_object
    bla = nil
    assert_equal nil, bla.name
    assert_equal true, bla.respond_to?(:name)
  end

  def test_proxy_obj
    bla = Proxy.new [1, 2, 3, 4, 5]

    assert_equal true, bla.respond_to?(:size)
    assert_equal true,  bla.respond_to?(:length)
    assert_equal false,  bla.respond_to?(:nhjnj)
    assert_equal 1, bla[0]
    assert_equal [2, 3, 4, 5, 6], bla.map(&:succ)
    assert_equal [4, 5, 6, 7, 8], bla.map { |e| e + 3 }
  end

  def test_delegate
    user = User.new 'Genadi', 'Samokovarov'
    invoice = Invoce.new(user)

    assert_equal 'Genadi', invoice.first_name
    assert_equal 'Samokovarov', invoice.last_name
  end
end
