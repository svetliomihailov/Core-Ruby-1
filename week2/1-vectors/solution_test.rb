require 'minitest/autorun'

require_relative 'solution'

class SolutionTest < Minitest::Test
  def test_vector2d_equal
    v_1 = Vector2D.new 1, 2
    v_2 = Vector2D.new 3, 4
    v_3 = Vector2D.new 1, 2

    assert_equal true, v_1 == v_3
    assert_equal false, v_1 == v_2
    assert_equal false, v_1 == 2
  end

  def test_vector2d_addition
    v_1 = Vector2D.new 1, 2
    v_2 = Vector2D.new 3, 4

    assert_equal Vector2D.new(4, 6), v_1 + v_2
    assert_equal Vector2D.new(8, 9), v_1 + 7

    assert_raises(RuntimeError) { assert_equal Vector2D.new(8, 9), v_1 + '7' }
  end

  def test_vector2d_substraction
    v_1 = Vector2D.new 1, 2
    v_2 = Vector2D.new 3, 4

    assert_equal Vector2D.new(-2, -2), v_1 - v_2
    assert_equal Vector2D.new(0, 1), v_1 - 1
    assert_raises(RuntimeError) { assert_equal Vector2D.new(8, 9), v_1 - '7' }
  end

  def test_vector2d_multiplication
    v_2 = Vector2D.new 3, 4

    assert_equal Vector2D.new(6, 8), v_2 * 2
  end

  def test_vector2d_division
    v_2 = Vector2D.new 3, 4

    assert_equal Vector2D.new(1.5, 2), v_2 / 2
  end

  def test_vector2d_unary_minus
    assert_equal Vector2D.new(-2, -4), -Vector2D.new(2, 4)
    assert_equal Vector2D.new(-2, 4), -Vector2D.new(2, -4)
    assert_equal Vector2D.new(2, -4), -Vector2D.new(-2, 4)
  end

  def test_vector2d_self_i
    assert_equal Vector2D.new(1, 0), Vector2D.i
  end

  def test_vector2d_self_j
    assert_equal Vector2D.new(0, 1), Vector2D.j
  end

  def test_vector_equal
    v_1 = Vector.new(1, 2, 3, 4)
    v_2 = Vector.new(1, 2, 3, 4)
    assert_equal true,  v_1 == v_2
    assert_equal false, Vector.new(1, 2, 3, 4) == Vector.new(1, 2, 3)
    assert_equal false, Vector.new(1, 2, 3, 4) == 'Vector'
  end

  def test_vector_addition
    assert_equal Vector.new(3, 4, 5, 6, 7), Vector.new(1, 2, 3, 4, 5) + 2
    assert_raises(RuntimeError) do
      assert_equal Vector.new(3, 4), Vector.new(1, 2) + 'Vector'
    end
    assert_raises(RuntimeError) do
      assert_equal Vector.new(3, 4, 5, 6, 7), \
                   Vector.new(1, 2, 3, 4, 5) + Vector.new(1, 2)
    end
    assert_equal Vector.new(3, 4, 5, 6, 7), \
                 Vector.new(1, 2, 3, 4, 5) + Vector.new(2, 2, 2, 2, 2)
  end

  def test_vector_substraction
    assert_equal Vector.new(-1, 0, 1, 2, 3), Vector.new(1, 2, 3, 4, 5) - 2
    assert_raises(RuntimeError) do
      assert_equal Vector.new(3, 4), Vector.new(1, 2) - 'Vector'
    end
    assert_raises(RuntimeError) do
      assert_equal Vector.new(3, 4, 5, 6, 7), \
                   Vector.new(1, 2, 3, 4, 5) - Vector.new(1, 2)
    end
    assert_equal Vector.new(-1, 0, 1, 2, 3), \
                 Vector.new(1, 2, 3, 4, 5) - Vector.new(2, 2, 2, 2, 2)
  end

  def test_vector_multiplication
    v_2 = Vector.new 3, 4, 5, 6

    assert_equal Vector.new(6, 8, 10, 12), v_2 * 2
    assert_raises(RuntimeError) { v_2 * 'String' }
  end

  def test_vector_division
    v_2 = Vector.new 3, 4, 5, 6

    assert_equal Vector.new(1.5, 2, 2.5, 3), v_2 / 2
    assert_raises(RuntimeError) { v_2 / 'String' }
  end

  def test_vector_index_operator
    v = Vector.new 1, 2, 3, 4, 5
    assert_equal 2, v[1]
    assert_equal 5, v[4]
    assert_raises(IndexError) { v[5] }
    assert_raises(IndexError) { v[-1] }
  end

  def test_vector_index_with_assign
    v = Vector.new 1, 2, 3, 4, 5
    assert_equal 3, v[2]
    assert_equal 1, v[2] = 1
    assert_equal 1, v[2]
    assert_raises(IndexError) { v[-1] = 5 }
  end

  def test_vector_unary_minus
    v_1 = Vector.new 1, 2, 3, 4

    assert_equal Vector.new(-1, -2, -3, -4), -v_1
  end

  def test_vector3d_dimension
    v3 = Vector3D.new 1, 2, 3
    assert_equal 3, v3.dimension
    assert_equal(true, v3.is_a?(Vector))
  end
end
