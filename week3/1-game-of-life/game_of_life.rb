require_relative 'solution'

include GameOfLife

SPACE_SHIP =
  Board.new [9, 20], [8, 21], [10, 21], [7, 22], [11, 22], [8, 23],\
            [9, 23], [10, 23], [6, 25], [7, 25], [11, 25], [12, 25],\
            [4, 26], [8, 26], [10, 26], [14, 26], [3, 27], [4, 27],\
            [8, 27], [10, 27], [14, 27], [15, 27], [2, 28], [8, 28],\
            [10, 28], [16, 28], [3, 29], [5, 29], [6, 29], [8, 29],\
            [10, 29], [12, 29], [13, 29], [15, 29]

def fun_times(board)
  b = board
  loop do
    system('cls')
    bd = BoardViewer.new b
    bd.display_board_with_y_axis
    b = b.next_generation
    sleep(0.2)
  end
end

fun_times SPACE_SHIP
