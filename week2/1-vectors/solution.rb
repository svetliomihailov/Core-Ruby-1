class Vector
  attr_reader :dimension, :components

  def initialize(*args)
    @components, @dimension = [], 0
    args.flatten.each do |e|
      fail ArgumentError, 'Ilegal Argument' unless e.is_a? Numeric
      @components << e.to_f
      @dimension += 1
    end
  end

  def length
    Math.sqrt @components.map { |e| e**2 }.reduce(:+)
  end

  alias_method :magnitude, :length

  def normalize
    len = length
    Vector.new @components.map { |e| e / len }
  end

  def ==(other)
    if other.is_a?(Vector) && other.dimension == @dimension
      @components == other.components
    else
      false
    end
  end

  def +(other)
    if other.is_a? Numeric
      Vector.new(*@components.map { |e| e + other })
    elsif other.instance_of? Vector
      fail ArgumentError, 'Illegal Argument' unless @dimension == other.dimension
      Vector.new(*@components.zip(other.components).map { |x, y| y + x })
    else
      fail ArgumentError, 'Illegal Argument'
    end
  end

  def -(other)
    if other.is_a? Numeric
      Vector.new(*@components.map { |e| e - other })
    elsif other.instance_of? Vector
      fail ArgumentError, 'Illegal Argument' unless @dimension == other.dimension
      Vector.new(*@components.zip(other.components).map { |x, y| x - y })
    else
      fail ArgumentError, 'Illegal Argument'
    end
  end

  def *(other)
    if other.is_a? Numeric
      Vector.new(*@components.map { |e| e * other })
    else
      fail ArgumentError, 'Illegal Argument'
    end
  end

  def /(other)
    if other.is_a? Numeric
      Vector.new(*@components.map { |e| e / other })
    else
      fail ArgumentError, 'Illegal Argument'
    end
  end

  def [](index)
    fail IndexError if index >= @dimension && index >= 0
    fail IndexError if index < -@dimension && index < 0
    @components[index]
  end

  def []=(index, value)
    fail IndexError if index >= @dimension && index >= 0
    fail IndexError if index < -@dimension && index < 0
    @components[index] = value
  end

  def +@
    Vector.new(*@components.map(&:+@))
  end

  def -@
    Vector.new(*@components.map(&:-@))
  end

  def to_s
    str = '('
    @components.each { |e| str += e.to_s + ', ' }
    str.chomp!(', ')
    str += ')'
  end

  def inspect
    '#Vector:' + to_s
  end
end

class Vector2D < Vector
  def initialize(x, y)
    super
  end

  def x
    @components[0]
  end

  def x=(value)
    @components[0] = value
  end

  def y
    @components[1]
  end

  def y=(value)
    @components[1] = value
  end

  def inspect
    '#Vector2D:' + to_s
  end

  def self.i
    Vector2D.new 1, 0
  end

  def self.j
    Vector2D.new 0, 1
  end
end

class Vector3D < Vector
  def initialize(x, y, z)
    super
  end

  def x
    @components[0]
  end

  def x=(value)
    @components[0] = value
  end

  def y
    @components[1]
  end

  def y=(value)
    @components[1] = value
  end

  def z
    @components[2]
  end

  def z=(value)
    @components[2] = value
  end

  def inspect
    '#Vector3D:' + to_s
  end
end
