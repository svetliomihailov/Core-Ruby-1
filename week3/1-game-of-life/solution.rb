module GameOfLife
  CELL_LIVES = 1
  CELL_DEAD = nil

  class Board
    def initialize(*args)
      @b = {}
      args.each do |a|
        fail ArgumentError, 'Wrong argument type!' \
          unless a.instance_of?(Array) && a.length == 2
        @b.merge! Cell.new(a[0], a[1]) => CELL_LIVES
      end
    end

    def [](x, y)
      @b.key? Cell.new(x, y)
    end

    def each
      return @b.enum_for(:each) unless block_given?
      @b.each { |k, v|yield k, v }
    end

    def count
      @b.size
    end

    def next_generation
      alive_cells = next_gen_alive_cells
      dead_cells = all_dead_neighbouts
      dead_cells.each { |e| alive_cells << e if cell_reincarnates?(e) }
      Board.new(*alive_cells.map { |e| [e.x, e.y] })
    end

    def hash
      @b.hash
    end

    def ==(other)
      hash == other.hash
    end

    def display_board
      board = fill_display_array create_display_array
      draw_display_array board
    end

    private

    def all_dead_neighbouts
      dead_cells = []
      @b.each { |k, _v| dead_cells |= neighbours(k) }
      dead_cells
    end

    def next_gen_alive_cells
      alive_cells = []
      @b.each_key { |k| alive_cells << k if cell_lives?(k) }
      alive_cells
    end

    def neighbours(cell)
      [Cell.new(cell.x, cell.y + 1), Cell.new(cell.x, cell.y - 1), \
       Cell.new(cell.x + 1, cell.y + 1), Cell.new(cell.x + 1, cell.y), \
       Cell.new(cell.x + 1, cell.y - 1), Cell.new(cell.x - 1, cell.y + 1), \
       Cell.new(cell.x - 1, cell.y), Cell.new(cell.x - 1, cell.y - 1)]
    end

    def alive_neighbours(cell)
      a = 0
      neighbours(cell).each { |e| a += 1 if @b.key?(e) }
      a
    end

    def cell_lives?(cell)
      cnt = alive_neighbours cell
      return true if cnt == 2 || cnt == 3
      false
    end

    def cell_reincarnates?(cell)
      return true if alive_neighbours(cell) == 3
      false
    end
# Displat help functions - may be make a separate class for displaying..
    def row_offset
      @row_offset = 0
      @b.each_key do |e|
        @row_offset = e.y.abs if e.y.abs > @row_offset if e.y < 0
      end
      @row_offset
    end

    def col_offset
      @col_offset = 0
      @b.each_key do |e|
        @col_offset = e.x.abs if e.x.abs > @col_offset if e.x < 0
      end
      @col_offset
    end

    def create_display_array
      row, col = 0, 0
      @b.each_key do |e|
        col = e.x.abs if e.x.abs >= col
        row = e.y.abs if e.y.abs >= row
      end
      Array.new(row + 1 + row_offset) { Array.new(col + 1 + col_offset) }
    end

    def fill_display_array(array)
      ar = array.map { |e| e.fill('x') }
      @b.each_key { |e| ar[e.y + @row_offset][e.x + @col_offset] = 'O' }
      ar
    end

    def draw_display_array(array)
      i = array.length - 1
      while i > -1
        j = 0
        while j < array[0].length
          print "#{array[i][j]} "
          j += 1
        end
        print "\n"
        i -= 1
      end
    end
  end

  class Cell
    def initialize(x, y)
      fail(ArgumentError, 'x and y must be integers!') \
        unless x.is_a?(Integer) && y.is_a?(Integer)
      @c = [x, y]
    end

    def x
      @c[0]
    end

    def y
      @c[1]
    end

    def ==(other)
      fail ArgumentError, 'Cell type expected' unless other.instance_of? Cell
      @c[0] == other.x && @c[1] == other.y
    end

    def eql?(other)
      return false unless other.instance_of? Cell
      hash == other.hash
    end

    def hash
      @c.hash
    end
  end
end
