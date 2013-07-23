class Board

  attr_reader :grid #:pieces

  def Board.generate_board
    grid = (0...8).map { ['*'] * 8 }

    grid[0] = [Rook.new(:black, [0,0], grid), Knight.new(:black, [0, 1], grid),
                Bishop.new(:black, [0, 2], grid), Queen.new(:black, [0,3], grid),
                King.new(:black, [0, 4], grid), Bishop.new(:black, [0,5], grid),
                Knight.new(:black, [0, 6], grid), Rook.new(:black, [0,7], grid)]

    grid[7] = [Rook.new(:white, [7,0], grid), Knight.new(:white, [7, 1], grid),
                Bishop.new(:white, [7, 2], grid), Queen.new(:white, [7,3], grid),
                King.new(:white, [7, 4], grid), Bishop.new(:white, [7,5], grid),
                Knight.new(:white, [7, 6], grid), Rook.new(:white, [7,7], grid)]

    grid[1].each_index do |i|
      grid[1][i] = Pawn.new(:black, [1, i], grid)
    end

    grid[6].each_index do |i|
      grid[6][i] = Pawn.new(:white, [6, i], grid)
    end

    grid
  end

#   def assess_grid
#     @pieces = []
#     # @grid.each_index do |row|
# #       row.each_index do |col|
# #         square = @grid[row][col]
# #        @pieces << square unless square.nil?
# #       end
# #     end
#     @grid.flatten.each
#
#   end

  def display_board
    print '  '
    (0...@grid.length).each { |i| print i.to_s(8) + " " }

    puts ""
    @grid.flatten.each_with_index do |piece, i|
      print (i /@grid.length).to_s(8) + " " if (i % @grid.length == 0)

      print piece.to_s + " "
      puts "" if (i + 1) % @grid.length == 0

    end

    return
  end

  def square_occupied?(row, col) #until test out, keep parameters
    self[row, col] != '*'
  end

  def [](row, col)
    @grid[row][col]
  end

  def initialize
    @grid = Board.generate_board
    #@pieces = self.assess_grid
  end


end

class Piece
  attr_accessor :color, :position, :grid

  def initialize(color, position, grid)
    @color, @position, @grid = color, position, grid
  end

end

module SlidingPiece

  def horizontal(final_position)
    horizontal = []

    delta_x = final_position[0] - position[0]
    delta_y = final_position[1] - position[1]

    return nil unless delta_x == 0

    h_step = delta_y/(delta_y.abs)

    j = position[1]

    until horizontal.include?(final_position)
      horizontal << [position[0], j + h_step]
      j += h_step
    end

    horizontal
  end

  def vertical(final_position)
    vertical = []

    delta_x = final_position[0] - position[0]
    delta_y = final_position[1] - position[1]

    return nil unless delta_y == 0

    v_step = delta_x/(delta_x.abs)

    i = position[0]

    until vertical.include?(final_position)
      vertical << [i + v_step, position[1]]
      i += v_step
    end

    vertical
  end

  def diagonal(final_position)
    diagonal = []

    delta_x = final_position[0] - position[0]
    delta_y = final_position[1] - position[1]

    return nil unless delta_x.abs == delta_y.abs

    v_step = delta_x/(delta_x.abs)
    h_step = delta_y/(delta_y.abs)

    i = position[0]
    j = position[1]

    until diagonal.include?(final_position)
      diagonal << [i + v_step, j + h_step]
      i += v_step
      j += h_step
    end

    diagonal

  end

  # def valid_move?
#
#   end

  def intervening_piece?

  end

  def teammate?

  end

  def own_king_checked?

  end

end

class Rook < Piece
  include SlidingPiece

  def to_s
    "R"
  end
end

class Bishop < Piece
  include SlidingPiece
  def to_s
    "B"
  end
end

class Queen < Piece
  include SlidingPiece
  def to_s
    "Q"
  end
end

class King < Piece
  # include SlidingPiece
  def to_s
    "K"
  end
end

class Pawn < Piece
  def to_s
    "P"
  end
end

class Knight < Piece
  def to_s
    "N"
  end
end