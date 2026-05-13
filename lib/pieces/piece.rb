class Piece
  attr_accessor :position, :color
  # Use Unicode: for the chess pieces
  
  def initialize(color, position)
    @color = color
    @position = position
  end

  # Returns array of potential coordinates based on piece rules
  #  Doesn't account for 'moving into check' yet
  def available_moves(board)
    raise NotImplementedError
  end

  def inside_bounds?(row, col)
    row.between?(0, 7) && col.between?(0, 7)
  end
end