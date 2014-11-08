require 'minitest/autorun'

require_relative 'solution'

class CellClassTest < Minitest::Test
  include GameOfLife

  def test_cell_creation
    assert_raises(ArgumentError) { Cell.new 2, 'a' }
    assert_raises(ArgumentError) { Cell.new 'b', 1 }
  end

  def test_cell_equal
    cell_1, cell_2 = Cell.new(1, 2), Cell.new(1, 2)
    cell_3 = Cell.new(2, 2)
    assert_equal true, cell_1 == cell_2
    assert_equal false, cell_1 == cell_3
    assert_raises(ArgumentError) { Cell.new(1, 2) == 'Cell' }
  end

  def test_cell_eql?
    cell_1, cell_2 = Cell.new(1, 2), Cell.new(1, 2)
    cell_3 = Cell.new(2, 2)
    assert_equal true, cell_1.eql?(cell_2)
    assert_equal false, cell_1.eql?(cell_3)
    assert_equal false, cell_1.eql?('Cell')
  end

  def test_cell_hash
    cell_1, cell_2 = Cell.new(-45, 52), Cell.new(-45, 52)
    cell_3, cell_4 = Cell.new(-45, -45), Cell.new(27, 52)
    assert_equal true, cell_1.hash == cell_2.hash
    assert_equal false, cell_1.hash == cell_3.hash
    assert_equal false, cell_1.hash == cell_4.hash
  end
end

class BoardClassTest < Minitest::Test
  include GameOfLife

  def new_board
    Board.new [0, 0], [0, 1], [1, 0], [1, 2], [2, 1], [3, 2]
  end

  def test_board_creation
    assert_raises(ArgumentError) { Board.new [1, 2], [2, 1], [3, 2, 3] }
  end

  def test_board_index
    b = new_board
    assert_equal true, b[1, 2]
    assert_equal true, b[2, 1]
    assert_equal false, b[3, 4]
  end

  def test_board_count
    b = new_board
    assert_equal 6, b.count
  end

  def test_board_each
    b = new_board
    enum = b.each
    assert_equal true, enum.instance_of?(Enumerator)
    enum.each { |_k, v| assert_equal false, v.nil? }
    b.each { |_k, v| assert_equal false, v.nil? }
  end

  def test_board_next_generation
    b = new_board
    b.cell_lives? Cell.new(0, 1)
  end
end
