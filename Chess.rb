class Board
#   DEFAULT_PIECES = [K, Q, R, etc]

   attr_reader :pieces, :squares

  def Board.generate_board
    @grid = (0...8).map { [nil] * 8 }

    @grid[0] = [Rook.new(:black, [0,0]), Knight.new(:black, [0, 1]),
                Bishop.new(:black, [0, 2]), Queen.new(:black, [0,3]),
                King.new(:black, [0, 4]), Bishop.new(:black, [0,5]),
                Knight.new(:black, [0, 6), Rook.new(:black, [0,7])]

    @grid[7] = [Rook.new(:white, [7,0]), Knight.new(:white, [7, 1]),
                Bishop.new(:white, [7, 2]), Queen.new(:white, [7,3]),
                King.new(:white, [7, 4]), Bishop.new(:white, [7,5]),
                Knight.new(:white, [7, 6), Rook.new(:white, [7,7])]

    @grid[1].each_with_index do |square, i|
      square = Pawn.new(:black, [1, i])
    end

    @grid[6].each_with_index do |square, i|
      square = Pawn.new(:white, [6, i])
    end
  end

  def Board.assess_board
    @pieces = []
    @grid.each do |row|
      row.each do |col|
        square = @grid[row][col]
       @pieces << square unless square.nil?
      end
    end
  end

  def initialize
    @board = Board.generate_board
    @pieces = Board.assess_board
  end


end

class Piece
  attr_accessor :color, :position

  def initialize(color, position)
    @color, @position = color, position
  end

end

module SlidingPiece

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