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
    assert_equal [6, 7, 8, 9, 10], collection.map { |e| e + 5 }
    assert_equal true, collection.map.is_a?(Enumerator)
  end

  def test_filter
    collection = Collection.new(*1..10)

    assert_equal [1, 3, 5, 7, 9], collection.filter(&:odd?)
    assert_equal [2, 4, 6, 8, 10], collection.filter(&:even?)
    assert_equal true, collection.filter.is_a?(Enumerator)
  end

  def test_reject
    collection = Collection.new(*1..10)

    assert_equal [1, 3, 5, 7, 9], collection.reject(&:even?)
    assert_equal [2, 4, 6, 8, 10], collection.reject(&:odd?)
    assert_equal true, collection.reject.is_a?(Enumerator)
  end

  def test_reduce
    collection = Collection.new(*1..10)
    collection_2 = Collection.new(*1..2)
    collection_3 = Collection.new(*1..1)

    assert_equal 1, collection_3.reduce { |a, e| a + e }
    assert_equal 3, collection_2.reduce { |a, e| a + e }
    assert_equal 55, collection.reduce(0) { |a, e| a + e }
    assert_equal 55, collection.reduce { |a, e| a + e }
    assert_equal 1, collection.reduce
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

    assert_equal(true, collection.any? { |e| e > 0 })
    assert_equal(false, collection.any? { |e| e < 0 })
    assert_equal(true, collection.any?)
    assert_equal(false, collection2.any?)
    assert_equal(true, collection3.any?)
  end

  def test_all?
    collection = Collection.new(*1..6)
    collection2 = Collection.new(*0..6)
    collection3 = Collection.new(1, false, 0, 4, 5, 6)

    assert_equal(true, collection.all? { |e| e > 0 })
    assert_equal(false, collection2.all? { |e| e > 0 })
    assert_equal(true, collection2.all?)
    assert_equal(false, collection3.all?)
  end

  def test_size
    col = Collection.new
    col_1 = Collection.new(1, 2)
    col_2 = Collection.new([1, 2, 3], 2)

    assert_equal 0, col.size
    assert_equal 2, col_1.size
    assert_equal 2, col_2.size
  end

  def test_count
    collection = Collection.new(*1..10)
    collection_2 = Collection.new(1, 1, 1, 2, 3, 4, 4, 4)

    assert_equal 1, collection.count(5)
    assert_equal 1, collection.count(9)
    assert_equal 10, collection.count(nil)
    assert_equal 3, collection_2.count(4)
    assert_equal 5, collection_2.count { |e| e > 1 }
    assert_equal 3, collection_2.count { |e| e == 4 }
  end

  def test_each_cons
    collection = Collection.new(*1..5)
    array = []

    collection.each_cons(2) { |e| array << e }

    assert_equal [1, 2], array[0]
    assert_equal [2, 3], array[1]
    assert_equal [3, 4], array[2]
    assert_equal [4, 5], array[3]
    assert_equal nil, array[4]

    array.clear
    collection.each_cons(3) { |e| array << e }

    assert_equal [1, 2, 3], array[0]
    assert_equal [2, 3, 4], array[1]
    assert_equal [3, 4, 5], array[2]
    assert_equal nil, array[3]

    assert_equal true, collection.each_cons(2).is_a?(Enumerator)
  end

  def test_group_by
    collection = Collection.new(*1..6)

    assert_equal({ 0 => [3, 6], 1 => [1, 4], 2 => [2, 5] }, \
                 collection.group_by { |i| i % 3 })
    assert_equal({ 0 => [2, 4, 6], 1 => [1, 3, 5] },
                 collection.group_by { |i| i % 2 })
    assert_equal true, collection.group_by.is_a?(Enumerator)
  end

  def test_min
    collection = Collection.new('albatross', 'dog', 'horse')

    assert_equal 'dog', collection.min { |a, b| a.length <=> b.length }
    assert_equal 'albatross', collection.min { |a, b| a <=> b }
    assert_equal 'albatross', collection.min
  end

  def test_min_by
    collection = Collection.new('albatross', 'dog', 'horse')

    assert_equal('dog', collection.min_by(&:length))
    assert_equal true, collection.min_by.is_a?(Enumerator)
  end

  def test_max
    collection = Collection.new('albatross', 'dog', 'horse')

    assert_equal 'albatross', collection.max { |a, b| a.length <=> b.length }
    assert_equal 'horse', collection.max { |a, b| a <=> b }
    assert_equal 'horse', collection.max
  end

  def test_max_by
    collection = Collection.new('albatross', 'dog', 'horse')

    assert_equal 'albatross', collection.max_by(&:length)
    assert_equal('horse', collection.max_by { |a| a })
    assert_equal true, collection.max_by.is_a?(Enumerator)
  end

  def test_take
    collection = Collection.new(*1..6)

    assert_equal [1, 2, 3], collection.take(3)
    assert_equal [1, 2, 3, 4, 5, 6], collection.take(8)
  end

  def test_take_while
    collection = Collection.new(*1..6)

    assert_equal [1, 2, 3], collection.take_while { |e| e < 4 }
    assert_equal true, collection.take_while.is_a?(Enumerator)
  end

  def test_drop
    collection = Collection.new(*1..6)

    assert_equal [4, 5, 6], collection.drop(3)
    assert_equal [], collection.drop(8)
  end

  def test_drop_while
    collection = Collection.new(*1..6)

    assert_equal [4, 5, 6], collection.drop_while { |e| e < 4 }
    assert_equal true, collection.drop_while.is_a?(Enumerator)
  end

  def test_minmax
    collection = Collection.new('albatross', 'dog', 'horse')

    assert_equal %w(dog albatross), \
                 collection.minmax { |x, y| x.length <=> y.length }
    assert_equal %w(albatross horse), collection.minmax
  end

  def test_minmax_by
    collection = Collection.new('albatross', 'dog', 'horse')

    assert_equal %w(dog albatross), collection.minmax_by(&:length)
    assert_equal %w(albatross horse), collection.minmax_by { |x| x }
    assert_equal true, collection.minmax_by.is_a?(Enumerator)
  end
end
