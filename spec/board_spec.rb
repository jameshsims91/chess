require

desribe Board do
  let(:board) { Board.new }

  describe "#in_check?" do
    it "returns true when the king is under attack" do
      board.add_piece(King.new(:white), [0, 0])
      board.add_piece(Rook.new(:black), [0, 5])
      expect(board.in_check?(:white)).to be true
    end
  end

  describe "validation" do
    it "prevents a piece from moving if it exposes the king" do
      # Set up a pinned piece scenario
      # Assert move_valid?(pinned_piece_move) is false
    end
  end
end