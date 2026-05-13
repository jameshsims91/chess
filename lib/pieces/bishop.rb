require_relative 'piece'

class Bishop < Piece
  # The four diagonal directional vectors
  DIRECTIONS = [
    [-1, -1], # Up-Left
    [-1,  1], # Up-Right
    [ 1, -1], # Down-Left
    [ 1,  1]  # Down-Right
  ].freeze

  def available_moves(board)
    moves = []

    DIRECTIONS.each do |dr, dc|
      current_row, current_col = position

      loop do
        current_row += dr
        current_col += dc
        
        # Stop scanning if we fall off the 8x8 grid boundaries
        break unless inside_bounds?(current_row, current_col)

        target_piece = board.grid[current_row][current_col]

        if target_piece.nil?
          moves << [current_row, current_col]
        elsif target_piece.color != self.color
          moves << [current_row, current_col] # Capture enemy piece
          break                                # Path is blocked after capture
        else
          break # Path is blocked by a teammate
        end
      end
    end

    moves
  end

  def to_s
    color == :white ? "♗" : "♝"
  end
end