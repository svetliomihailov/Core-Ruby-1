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
      # Returns new Board with the living cells
    end

    def cell_dies?(cell)
      cnt = cell_neighbours cell
      return false if cnt == 2 || cnt == 3
      true
    end

    def cell_lives?(cell)
      cnt = cell_neighbours cell
      return true if cnt == 2 || cnt == 3
      false
    end 

    private
    
    def this_cell_clumn(cell)
      cnt = 0
      cnt += 1 if @b.key? Cell.new(cell.x, cell.y + 1)
      cnt += 1 if @b.key? Cell.new(cell.x, cell.y - 1)
      cnt
    end

    def right_cell_column(cell)
      cnt = 0
      cnt += 1 if @b.key? Cell.new(cell.x + 1, cell.y + 1)
      cnt += 1 if @b.key? Cell.new(cell.x + 1, cell.y)
      cnt += 1 if @b.key? Cell.new(cell.x + 1, cell.y - 1)
      cnt
    end

    def left_cell_column(cell)
      cnt = 0
      cnt += 1 if @b.key? Cell.new(cell.x - 1, cell.y + 1)
      cnt += 1 if @b.key? Cell.new(cell.x - 1, cell.y)
      cnt += 1 if @b.key? Cell.new(cell.x - 1, cell.y - 1)
      cnt
    end

    def cell_neighbours(cell)
      left_cell_column(cell) + right_cell_column(cell) + this_cell_clumn(cell)
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
