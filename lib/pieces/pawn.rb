require_relative 'piece'

class Pawn < Piece
  def available_moves(board)
    moves = []
    row, col = position

    direction = (color == :white) ? -1 : 1
    start_row = (color == :white) ? 6 : 1

    next_row = row + direction
    if inside_bounds?(next_row, col) && board.grid[next_row][col].nil?
      moves << [next_row, col]

      two_step_row = row + (direction * 2)
      if row == start_row && board.grid[two_step_row][col].nil?
        moves << [two_step_row, col]
      end
    end

    diagonal_cols = [col - 1, col + 1]
    diagonal_cols.each do |diag_col|
      next unless inside_bounds?(next_row, diag_col)
      target_piece = board.grid[next_row][diag_col]

      if target_piece && target_piece.color != self.color
        moves << [next_row, diag_col]
      end
    end

    moves
  end

  def to_s
    color == :white ? "♙" : "♟"
  end
end