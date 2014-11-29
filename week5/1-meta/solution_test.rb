require 'minitest/autorun'

require_relative 'solution'

class Object
  def heil
    puts 'hello from Object'
  end
end

class Bla
  private_attr_accessor :a
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
    a = Object.new.method(:heil)
    assert_equal false, a.respond_to?(:hello)
    a.define_singleton_method(:hello, a)
    assert_equal true, a.respond_to?(:hello)
    assert_raises(NoMethodError) { Object.new.hello }
  end

  def test_string_to_proc
    assert_equal [2, 3, 4, 5].map(&'succ'), [3, 4, 5, 6]
    assert_equal [2, 3, 4, 5].map(&'succ.succ'), [4, 5, 6, 7]
    assert_equal [2, 3, 4, 5].map(&'succ.succ.pred'), [3, 4, 5, 6]
  end

  def test_module_private_accessor
    b = Bla.new
    p b.a
    b.a = 2
    p b.a
  end
end
