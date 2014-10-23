module MyEnumerable
  def map
    return self.enum_for(:each) unless block_given?
    array = []
    self.each { |el| array << yield(el) }
    array
  end

  def filter
    return self.enum_for(:each) unless block_given?
    array = []
    self.each { |el| array << el if yield(el) }
    array
  end

  def reject
    return self.enum_for(:each) unless block_given?
    array = []
    self.each { |el| array << el unless yield el }
    array
  end

  def reduce(initial = nil)
    #if initial.nil?
      # TODO: finish this method...
    #else
    self.each { | el | initial = yield initial, el } if block_given?
    initial
    #end
  end

  def any?
    if block_given?
      self.each { |el| return true if yield el }
    else
      self.each { |el| return true if el }
    end
    false
  end

  def all?
    if block_given?
      self.each { |el| return false unless yield el }
    else
      self.each { |el| return false unless el }
    end
    true
  end

  def each_cons(n)
    return self.enum_for(:each) unless block_given?
    enum, cnt = self.each, 0
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
    self.each { |el| return true if el == element }
    false
  end

  def count(element = nil)
    cnt = 0
    if element
      self.each { |e| cnt += 1 if element == e }
    else
      self.each do |e|
        should_inc =  block_given? ? yield(e) : true
        cnt += 1 if should_inc
      end
    end
    cnt
  end

  def size
    cnt = 0
    self.each { cnt += 1 }
    cnt
  end

  # Groups the collection by result of the block.
  # Returns a hash where the keys are the evaluated
  # result from the block and the values are arrays
  # of elements in the collection that correspond to
  # the key.
  def group_by
    return self.enum_for(:each) unless block_given?
    hash = Hash.new([])
    self.each do |e|
      res = yield e
      hash[res] = Array.new unless hash.key?(res)
      hash[res] << e
    end
    hash
  end

  def min
    enum = self.each
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
    return self.enum_for(:each) unless block_given?
    self.min { |a, b| yield(a) <=> yield(b) }
  end

  def max
    enum = self.each
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
    return self.enum_for(:each) unless block_given?
    self.max { |a, b| yield(a) <=> yield(b) }
  end

  def minmax
    ar = []
    if block_given?
      ar << self.min { |a, b| yield a, b }
      ar << self.max { |a, b| yield a, b }
    else
      ar << self.min
      ar << self.max
    end
  end

  def minmax_by
    return self.enum_for(:each) unless block_given?
    ar = []
    ar << self.min_by { |e| yield e }
    ar << self.max_by { |e| yield e }
  end

  def take(n)
    ar, cnt = [], 0
    self.each do | el |
      ar << el
      cnt += 1
      return ar if cnt == n
    end
    ar
  end

  def take_while
    return self.enum_for(:each) unless block_given?
    ar = []
    self.each do | e |
      if yield(e)
        ar << e 
      else 
        return ar
      end
    end
    ar
  end

  def drop(n)
    return [] if n >= self.size
    ar, cnt = [], 0
    self.each { |e| cnt += 1; ar << e if cnt > (self.size - n) }
    ar
  end

  def drop_while
    return self.enum_for(:each) unless block_given?
    ar = []
    self.each { | e | ar << e unless yield e }
    ar
  end

  alias_method :collect, :map
  alias_method :select, :filter
  alias_method :foldl, :reduce
end
