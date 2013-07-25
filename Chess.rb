# class Array
#
#   # def deep_dup
#     #   # Argh! Mario and Kriti beat me with a one line version?? Must
#     #   # have used `inject`...
#     #   new_array = []
#     #   self.each do |el|
#     #     if el.is_a?(Array)
#     #       new_array << el.deep_dup
#     #     else
#     #       new_array << el
#     #     end
#     #   end
#     #
#     #   new_array
#     # end
#
#   def deep_dup
#     # board = Board.new
#     new_array = []
#     self.each do |el|
#       if el.is_a?(Array)
#         new_array << el.deep_dup
#       else
#         new_array << el.dup # Later: el.dup
#       end
#     end
#
#     new_array
#   end
#
# end

class Board

  attr_accessor :grid #:pieces

  def Board.generate_board
    grid = (0...8).map { ['*'] * 8 }

    teams = make_teams(grid)

    grid[0] = 8.times.map { |i| teams[0][i] }

    grid[7] = 8.times.map { |i| teams[1][i] }

    grid[1] = (8...16).map { |i| teams[0][i] }

    grid[6] = (8...16).map { |i| teams[1][i] }

    [grid, teams]
  end

  def Board.make_teams(grid)

    bteam = [Rook.new(:black, [0,0], grid), Knight.new(:black, [0, 1], grid),
            Bishop.new(:black, [0, 2], grid), Queen.new(:black, [0,3], grid),
            King.new(:black, [0, 4], grid), Bishop.new(:black, [0,5], grid),
            Knight.new(:black, [0, 6], grid), Rook.new(:black, [0,7], grid)]

    8.times do |i|

      bteam << Pawn.new(:black, [1, i], grid)

    end


    wteam = [Rook.new(:white, [7,0], grid), Knight.new(:white, [7, 1], grid),
            Bishop.new(:white, [7, 2], grid), Queen.new(:white, [7,3], grid),
            King.new(:white, [7, 4], grid), Bishop.new(:white, [7,5], grid),
            Knight.new(:white, [7, 6], grid), Rook.new(:white, [7,7], grid)]


    8.times do |i|

      wteam << Pawn.new(:white, [6, i], grid)

    end

    [bteam, wteam]

  end

  def to_s
    print '  '
    (0...@grid[0].length).each { |i| print i.to_s(8) + " " }

    puts ""
    @grid[0].flatten.each_with_index do |piece, i|
      print (i /@grid[0].length).to_s(8) + " " if (i % @grid[0].length == 0)

      print piece.to_s + " "
      puts "" if (i + 1) % @grid[0].length == 0

    end

    return
  end

  def [](row, col)
    @grid[0][row][col]
  end

  def initialize(n = 'new')
    if n == 'new'
      @grid = Board.generate_board
    else
      @grid = Array.new { ['*'] * 8 }
    end
  end

  # def deep_dup
#     boardcopy = Board.new
#     boardcopy.grid = self.grid.deep_dup
#
#     boardcopy.grid.flatten.select do |el|
#       el.is_a?(Piece)
#     end.each { |piece| piece.grid = boardcopy.grid }
#
#     boardcopy
#   end

end

class Piece
  attr_accessor :color, :position, :grid# reformat later to include :final_position

  def initialize(color, position, grid)
    @color, @position, @grid = color, position, grid[0]
    @teams = { :black => grid[1][0],
               :white => grid[1][1],
               :blackking => grid[1][0][4],
               :whiteking => grid[1][1][4]
             }
  end


  def team

    @teams = Hash.new()
    @teams[:black] = @grid.flatten.select { |piece| piece != '*' && piece.color == :black }
    @teams[:white] = @grid.flatten.select { |piece| piece != '*' && piece.color == :white }
    @teams[:blackking] = @teams[:black].select { |piece| piece.is_a?(King) }.first
    @teams[:whiteking] = @teams[:white].select { |piece| piece.is_a?(King) }.first

    @teams

  end

  def path(final_position) #Refactor later
    return nil unless within_board?(final_position)

    path = []

    delta_x = final_position[0] - position[0]
    delta_y = final_position[1] - position[1]

    return nil unless path_permissible?(delta_x, delta_y)
    return [final_position] if self.is_a?(Knight)

    delta_x == 0 ? v_step = 0 : v_step = (delta_x / delta_x.abs)
    delta_y == 0 ? h_step = 0 : h_step = (delta_y / delta_y.abs)

    i, j = position

    until path.include?(final_position)
      path << [i + v_step, j + h_step]
      i += v_step
      j += h_step
    end

    path

  end

  def stationary?(final_position)
    position == final_position
  end

  def move(final_position)
    p final_position
    if execute_move?(final_position)
      p @grid
      @grid[final_position[0]][final_position[1]] = @grid[position[0]][position[1]]
      @grid[position[0]][position[1]]
      @grid[position[0]][position[1]] = '*'
      @position = final_position # MH
    end
  end

  def execute_move?(final_position)
    return false if stationary?(final_position)
    return false unless within_board?(final_position)
    return false if intervening_piece?(final_position)
    return false if destination_friend?(final_position)
    return false if own_king_checked?# unless save_the_day?(final_position)

    true
  end

   def intervening_piece?(final_position) #works
     return true if self.path(final_position) == nil
     path = self.path(final_position)[0...-1]
     path.any? { |point| grid[point[0]][point[1]].is_a?(Piece) }
   end

   def path_clear?(final_position)
     !(intervening_piece?(final_position))
   end

  def own_king_checked?
    p team[:white]
    p team[:black]

    if team[:white].include?(self)
      return (team[:black].any? { |piece| piece.path_clear?(team[:whiteking].position) })
    elsif team[:black].include?(self)
      return (team[:white].any? { |piece| piece.path_clear?(team[:blackking].position) })
    end

    false
  end

  def destination_friend?(final_position) #works
    return nil unless square_occupied?(final_position)
    row, column = final_position
    grid[row][column].color == self.color
  end

  def within_board?(final_position) #works
    row, column = final_position
    (row.between?(0,7) && column.between?(0,7))
  end

  def square_occupied?(final_position) ##works
    row, column = final_position
    grid[row][column].is_a?(Piece)
  end

  def save_the_day?(final_position)
    boardcopy = Board.new('la')
    x, y = final_position
    p grid
    8.times do |i|
      8.times do |j|
        p i
        boardcopy.grid[i][j] = (grid[i][j]).dup
        p i
        boardcopy.grid[i][j].grid = boardcopy.grid
      end
    end

    boardcopy.grid[position[0]][position[1]].move(final_position)
    boardcopy.grid[x][y].own_king_checked?
  end


end

class Rook < Piece

  def path_permissible?(delta_x, delta_y)
    ((delta_y == 0) ^ (delta_x == 0))
  end

  def to_s
    "R"
  end
end

class Bishop < Piece

  def path_permissible?(delta_x, delta_y)
    return false if (delta_x == 0 && delta_y == 0)
    delta_x.abs == delta_y.abs
  end

  def to_s
    "B"
  end
end

class Queen < Piece

  def path_permissible?(delta_x, delta_y)
    return false if (delta_x == 0 && delta_y == 0)
    ((delta_y == 0) ^ (delta_x == 0) || (delta_x.abs == delta_y.abs))
  end

  def to_s
    "Q"
  end
end

class King < Piece

  def path_permissible?(delta_x, delta_y)
    return false if (delta_x == 0 && delta_y == 0)
    !(delta_x.abs > 1 || delta_y.abs > 1)
  end

  def to_s
    "K"
  end
end

class Pawn < Piece

  def path_permissible?(delta_x, delta_y)

    deltas = [delta_x, delta_y]

    if self.color == :black
      if at_home_row?
        [[1,0], [2,0], [1,1], [1,-1]].include?(deltas)
      else
        [[1,0], [1,1], [1,-1]].include?(deltas)
      end
    elsif self.color == :white
      if at_home_row?
        [[-1,0], [-2,0], [-1,1], [-1,-1]].include?(deltas)
      else
        [[-1,0], [-1,1], [-1,-1]].include?(deltas)
      end
    end
  end

  def attacking?(final_position)

    delta_y = final_position[1] - position[1]

    if delta_y != 0
      return false unless square_occupied?(final_position)
      return true unless destination_friend?(final_position)
    else
      return false if square_occupied?(final_position)
    end

    true
  end

  def execute_move?(final_position)
    return false unless attacking?(final_position)
    super(final_position)
  end

  def at_home_row?
    color == :black ? position[0] == 1 : position[0] == 6
  end

  def to_s
    "P"
  end
end

class Knight < Piece

  def path_permissible?(delta_x, delta_y)
    [delta_x.abs, delta_y.abs].sort == [1,2]
  end

  def to_s
    "N"
  end
end