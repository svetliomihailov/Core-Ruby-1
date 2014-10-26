class Vector
  attr_reader :dimension, :components

  def initialize(*args)
    @components, @dimension = [], 0
    args.each do |e|
      fail 'Ilegal Argument' unless e.is_a? Numeric
      @components << e.to_f
      @dimension += 1
    end
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
    elsif other.is_a? Vector
      fail 'Illegal Argument' unless @dimension == other.dimension
      Vector.new(*@components.zip(other.components).map { |x, y| y + x })
    else
      fail 'Illegal Argument'
    end
  end

  def -(other)
    if other.is_a? Numeric
      Vector.new(*@components.map { |e| e - other })
    elsif other.is_a? Vector
      fail 'Illegal Argument' unless @dimension == other.dimension
      Vector.new(*@components.zip(other.components).map { |x, y| x - y })
    else
      fail 'Illegal Argument'
    end
  end

  def *(other)
    if other.is_a? Numeric
      Vector.new(*@components.map { |e| e * other })
    else
      fail 'Illegal Argument'
    end
  end

  def /(other)
    if other.is_a? Numeric
      Vector.new(*@components.map { |e| e / other })
    else
      fail 'Illegal Argument'
    end
  end

  def [](i)
    fail IndexError unless i < @dimension && i >= 0
    @components[i]
  end

  def []=(i, value)
    fail IndexError unless i < @dimension && i >= 0
    @components[i] = value
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
    @components, @dimension = [], 2
    @components << x.to_f
    @components << y.to_f
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
    @components, @dimension = [], 3
    @components << x.to_f
    @components << y.to_f
    @components << z.to_f
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
