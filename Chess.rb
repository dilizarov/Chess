class Board
#   DEFAULT_PIECES = [K, Q, R, etc]

   attr_reader :pieces, :grid

  def Board.generate_board
    grid = (0...8).map { ['*'] * 8 }

    grid[0] = [Rook.new(:black, [0,0]), Knight.new(:black, [0, 1]),
                Bishop.new(:black, [0, 2]), Queen.new(:black, [0,3]),
                King.new(:black, [0, 4]), Bishop.new(:black, [0,5]),
                Knight.new(:black, [0, 6]), Rook.new(:black, [0,7])]

    grid[7] = [Rook.new(:white, [7,0]), Knight.new(:white, [7, 1]),
                Bishop.new(:white, [7, 2]), Queen.new(:white, [7,3]),
                King.new(:white, [7, 4]), Bishop.new(:white, [7,5]),
                Knight.new(:white, [7, 6]), Rook.new(:white, [7,7])]

    grid[1].each_index do |i|
      grid[1][i] = Pawn.new(:black, [1, i])
    end

    grid[6].each_index do |i|
      grid[6][i] = Pawn.new(:white, [6, i])
    end

    grid
  end

  def assess_board
    @pieces = []
    self.each_index do |row|
      row.each_index do |col|
        square = self[row][col]
       @pieces << square unless square.nil?
      end
    end
  end

  def display_board
    print '  '
    (0...@grid.length).each do |i|
      print i.to_s(8) + " "
    end
    puts ""

    @grid.flatten.each_with_index do |piece, i|
      print (i /@grid.length).to_s(8) + " " if (i % @grid.length == 0)

      print piece.to_s + " "
      if (i + 1) % @grid.length == 0
        puts ""
      end
    end

    return
  end

  def square_occupied?(row, col) #until test out, keep parameters
    self[row, col] != '*'
  end

  def [](row, col) #Possibly error-prone
    @grid[row][col]
  end

  def initialize
    @grid = Board.generate_board
    #@pieces = @grid.assess_board
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