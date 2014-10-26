module MyEnumerable
  def map
    return enum_for(:each) unless block_given?
    array = []
    each { |el| array << yield(el) }
    array
  end

  def filter
    return enum_for(:each) unless block_given?
    array = []
    each { |el| array << el if yield(el) }
    array
  end

  def reject
    return enum_for(:each) unless block_given?
    array = []
    each { |el| array << el unless yield el }
    array
  end

  def reduce(initial = nil)
    enum, cnt = enum_for(:each) { size }, 0
    initial, cnt = enum.next, 1 if initial.nil?
    while cnt < enum.size
      if block_given?
        initial = yield initial, enum.next
      else
        break
      end
      cnt += 1
    end
    initial
  end

  def any?
    if block_given?
      each { |el| return true if yield el }
    else
      each { |el| return true if el }
    end
    false
  end

  def all?
    if block_given?
      each { |el| return false unless yield el }
    else
      each { |el| return false unless el }
    end
    true
  end

  def each_cons(n)
    cnt, enum = 0, enum_for(:each) { size }
    return enum unless block_given?
    while cnt <= (enum.size - n)
      enum.rewind
      cnt.times { enum.next }
      array = []
      n.times { array << enum.next }
      yield array
      cnt += 1
    end
  end

  def include?(element)
    each { |el| return true if el == element }
    false
  end

  def count(element = nil)
    cnt = 0
    if element
      each { |e| cnt += 1 if element == e }
    else
      each do |e|
        should_inc =  block_given? ? yield(e) : true
        cnt += 1 if should_inc
      end
    end
    cnt
  end

  def size
    cnt = 0
    each { cnt += 1 }
    cnt
  end

  # Groups the collection by result of the block.
  # Returns a hash where the keys are the evaluated
  # result from the block and the values are arrays
  # of elements in the collection that correspond to
  # the key.
  def group_by
    return enum_for(:each) unless block_given?
    hash = Hash.new([])
    each do |e|
      res = yield e
      hash[res] = Array.new unless hash.key?(res)
      hash[res] << e
    end
    hash
  end

  def min
    enum = enum_for(:each) { size }
    cnt, min_val = enum.size, enum.next
    while cnt > 1
      cur = enum.next
      i_min = block_given? ? yield(min_val, cur) : min_val <=> cur
      min_val = cur if i_min == 1
      cnt -= 1
    end
    min_val
  end

  def min_by
    return enum_for(:each) unless block_given?
    min { |a, b| yield(a) <=> yield(b) }
  end

  def max
    enum = enum_for(:each) { size }
    cnt, max_val = enum.size, enum.next
    while cnt > 1
      cur = enum.next
      i_max = block_given? ? yield(max_val, cur) : max_val <=> cur
      max_val = cur if i_max == -1
      cnt -= 1
    end
    max_val
  end

  def max_by
    return enum_for(:each) unless block_given?
    max { |a, b| yield(a) <=> yield(b) }
  end

  def minmax
    if block_given?
      [min { |a, b| yield a, b }, max { |a, b| yield a, b }]
    else
      [min, max]
    end
  end

  def minmax_by
    return enum_for(:each) unless block_given?
    [min_by { |e| yield e }, max_by { |e| yield e }]
  end

  def take(n)
    ar, cnt = [], 0
    each do | el |
      ar << el
      cnt += 1
      return ar if cnt == n
    end
    ar
  end

  def take_while
    return enum_for(:each) unless block_given?
    ar = []
    each do | e |
      if yield(e)
        ar << e
      else
        return ar
      end
    end
    ar
  end

  def drop(n)
    return [] if n >= size
    ar, cnt = [], 0
    each do |e|
      cnt += 1
      ar << e if cnt > (size - n)
    end
    ar
  end

  def drop_while
    return enum_for(:each) unless block_given?
    ar = []
    each { | e | ar << e unless yield e }
    ar
  end

  alias_method :collect, :map
  alias_method :select, :filter
  alias_method :foldl, :reduce
end
