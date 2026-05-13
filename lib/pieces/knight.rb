require_relative 'piece'

class Knight < Piece
  OFFSETS = [
    [-2, -1], [-2, 1], [-1, -2], [-1, 2],
    [1, -2],  [1, 2],  [2, -1],  [2, 1]
  ].freeze

  def available_moves(board)
    moves = []

    OFFSETS.each do |dr, dc|
      target_row = position[0] + dr
      target_col = position[1] + dc
      next unless inside_bounds?(target_row, target_col)

      target_piece = board.grid[target_row][target_col]

      if target_piece.nil? || target_piece.color != self.color
        moves << [target_row, target_col]
      end
    end

    moves
  end

  def to_s
    color == :white ? "♘" : "♞"
  end
end