require_relative 'piece'

class King < Piece
  attr_accessor :has_moved

  def initialize(color, position)
    super(color, position)
    @has_moved = false 
  end

  def available_moves(board)
    moves = []
    row, col = position

    offsets = [
      [-1, -1], [-1,  0], [-1,  1],
      [ 0, -1],           [ 0,  1],
      [ 1, -1], [ 1,  0], [ 1,  1]
    ]

    offsets.each do |dr, dc|
      target_row = row + dr
      target_col = col + dc

      next unless inside_bounds?(target_row, target_col)

      target_piece = board.grid[target_row][target_col]

      if target_piece.nil? || target_piece.color != self.color
        moves << [target_row, target_col]
      end
    end

    moves
  end

  def to_s
    color == :white ? "♔" : "♚"
  end
end
