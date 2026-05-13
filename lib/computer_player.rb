class ComputerPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_move(board)
    all_moves = []

    board.grid.each_with_index do |row_array, row_idx|
      row_array.each_with_index do |piece, col_idx|
        next if piece.nil? || piece.color != @color

        legal_destinations = board.legal_moves_for(piece)
        next if legal_destinations.nil? || legal_destinations.empty?

        start_pos = [row_idx, col_idx]
        legal_destinations.each do |end_pos|
          all_moves << [start_pos, end_pos]
        end
      end
    end

    all_moves.empty? ? nil : all_moves.sample
  end
end