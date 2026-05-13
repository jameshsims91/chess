require_relative 'pieces/piece'
require_relative 'pieces/king'
require_relative 'pieces/queen'
require_relative 'pieces/bishop'
require_relative 'pieces/rook'
require_relative 'pieces/pawn'
require_relative 'pieces/knight'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def setup_board
    setup_back_rank(:black, 0)
    setup_back_rank(:white, 7)

    8.times do |col|
      @grid[1][col] = Pawn.new(:black, [1, col])
      @grid[6][col] = Pawn.new(:white, [6, col])
    end
  end

  def move_piece(start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    piece = @grid[start_row][start_col]

    if piece.is_a?(King) && (start_col - end_col).abs == 2
      execute_castle(start_pos, end_pos)
      return
    end

    @grid[end_row][end_col] = piece
    @grid[start_row][start_col] = nil
    piece.position = [end_row, end_col] if piece
    piece.has_moved = true if piece.respond_to?(:has_moved)
  end

  def display
    puts "\n    a  b  c  d  e  f  g  h"
    puts "  +------------------------+"

    @grid.each_with_index do |row_array, row_idx|
      rank_label = 8 - row_idx
      print "#{rank_label} |"

      row_array.each_with_index do |piece, col_idx|
        bg_color = (row_idx + col_idx).even? ? "\e[48;5;248m" : "\e[48;5;240m"
        reset_code = "\e[0m"

        if piece.nil?
          print "#{bg_color} ∙ #{reset_code}"
        else
          print "#{bg_color} #{piece} #{reset_code}"
        end
      end

      puts "| #{rank_label}"
    end

    puts "  +------------------------+"
    puts "    a  b  c  d  e  f  g  h\n"
  end

  def in_check?(color)
    king_position = find_king(color)

    opposing_pieces(color).any? do |piece|
      piece.available_moves(self).include?(king_position)
    end
  end

  def legal_moves_for(piece)
    raw_moves = piece.available_moves(self)

    raw_moves.select do |target_pos|
      simulate_move(piece.position, target_pos) do
        !in_check?(piece.color)
      end
    end
  end

  def check_promotion(end_pos, replacement_class = nil)
    row, col = end_pos
    piece = @grid[row][col]

    return unless piece.is_a?(Pawn)

    promotion_row = (piece.color == :white) ? 0 : 7
    return unless row == promotion_row

    replacement_class ||= queen

    @grid[row][col] = replacement_class.new(piece.color, [row, col])
  end

  private

  def setup_back_rank(color, row)
    rank_classes = [Rook, Knight, Bishop, Queen, King, Knight, Rook]

    rank_classes.each_with_index do |piece_class, col|
      @grid[row][col] = piece_class.new(color, [row, col])
    end
  end

  def simulate_move(start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos

    original_start_piece = @grid[start_row][start_col]
    original_end_piece   = @grid[end_row][end_col]

    @grid[end_row][end_col] = original_start_piece
    @grid[start_row][start_col] = nil
    original_start_piece.position = [end_row, end_col] if original_start_piece

    evaluation_outcome = yield

    @grid[start_row][start_col] = original_start_piece
    @grid[end_row][end_col]     = original_end_piece
    original_start_piece.position = [start_row, start_col] if original_start_piece

    evaluation_outcome
  end

  def find_king(color)
    @grid.flatten.compact.find { |p| p.is_a?(King) && p.color == color }.position
  end

  def opposing_pieces(color)
    @grid.flatten.compact.select { |p| p.color != color }
  end
end