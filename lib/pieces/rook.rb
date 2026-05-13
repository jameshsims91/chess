require_relative 'piece'

class Rook < Piece
  DIRECTIONS = [[-1,0], [1, 0], [0, -1], [0,1]].freeze

  def available_moves(board)
    moves = []

    DIRECTIONS.each do |dr, dc|
      current_row, current_col = position

      loop do
        current_row += dr
        current_col += dc
        break unless inside_bounds?(current_row, current_col)

        target_piece = board.grid[current_row][current_col]

        if target_piece.nil?
          moves << [current_row, current_col]
        elsif target_piece.color != self.color
          moves << [current_row, current_col]
          break
        else
          break
        end
      end
    end

    moves
  end

  def to_s
    color == :white ? "♖" : "♜"
  end
  
end