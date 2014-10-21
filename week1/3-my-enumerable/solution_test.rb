require 'minitest/autorun'

require_relative 'solution'

class SolutionTest < Minitest::Test
  class Collection
    include MyEnumerable

    def initialize(*data)
      @data = data
    end

    def each(&block)
      @data.each(&block)
    end
  end

  def test_map
    collection = Collection.new(*1..5)

    assert_equal [2, 3, 4, 5, 6], collection.map(&:succ)
    assert_equal [6, 7, 8, 9, 10 ], collection.map {|e| e += 5}
  end

  def test_filter
    collection = Collection.new(*1..10)

    assert_equal [1, 3, 5, 7, 9], collection.filter(&:odd?)
    assert_equal [2, 4, 6, 8, 10], collection.filter(&:even?)
  end

  def test_reject
    collection = Collection.new(*1..10)

    assert_equal [1, 3, 5, 7, 9], collection.reject(&:even?)
    assert_equal [2, 4, 6, 8, 10], collection.reject(&:odd?)
  end

  def test_reduce
    collection = Collection.new(*1..10)

    assert_equal 55, collection.reduce(0) { |sum, n| sum + n }
    assert_equal 65, collection.reduce(0) { |sum, n| sum + n + 1 }
  end

  def test_include?
    collection = Collection.new(*1..10)

    assert_equal true, collection.include?(5)
    assert_equal false, collection.include?(11)
  end

  def test_any?
    collection = Collection.new(*1..10)
    collection2 = Collection.new(false, nil, false)
    collection3 = Collection.new(false, nil, false, 1)

    assert_equal (true), (collection.any? {|e| e > 0})
    assert_equal (false), (collection.any? {|e| e < 0})
    assert_equal (true), (collection.any? )
    assert_equal (false), (collection2.any? )
    assert_equal (true), (collection3.any? )
  end

  def test_all?
    collection = Collection.new(*1..6)
    collection2 = Collection.new(*0..6)
    collection3 = Collection.new(1, false, 0, 4, 5, 6)

    assert_equal (true), (collection.all? {|e| e > 0})
    assert_equal (false), (collection2.all? {|e| e > 0})
    assert_equal (true), (collection2.all?)
    assert_equal (false), (collection3.all?)
  end

  def test_size
    col = Collection.new()
    col_1 = Collection.new(1,2)
    col_2 = Collection.new([1, 2, 3], 2)

    assert_equal 0, col.size
    assert_equal 2, col_1.size
    assert_equal 2, col_2.size
  end

  def test_count
    collection = Collection.new(*1..10)
    collection2 = Collection.new(1,1,1,2,3,4,4,4)

    assert_equal 1, collection.count(5)
    assert_equal 1, collection.count(9)
    assert_equal 10, collection.count(nil)
    assert_equal 3, collection2.count(4)
  end

  def test_each_cons
    collection = Collection.new(*1..5)
    collection.each_cons(2) { | e | p e }
  end
end

