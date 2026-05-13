require 'yaml'
require_relative 'board'
require_relative 'input_parser'
require_relative 'computer_player'

class HumanPlayer
  attr_reader :color
  def initialize(color)
    @color = color
  end
end

class Game
  SAVE_PATH = 'saves/save.yaml'

  attr_accessor :player_white, :player_black, :current_player

  def initialize(vs_computer = false)
    @board = Board.new
    @board.setup_board

    @player_white = HumanPlayer.new(:white)
    @player_black = vs_computer ? ComputerPlayer.new(:black) : HumanPlayer.new(:white)

    @current_player = @player_white
  end
  
  def self.load_game
    if File.exist?(SAVE_PATH)
      yaml_data = File.read(SAVE_PATH)
      
      YAML.unsafe_load(yaml_data) 
    else
      puts "No saved game found. Starting a new game instead."
      nil
    end
  end

  def play
    loop do
      @board.display
      
      if @current_player.is_a?(ComputerPlayer)
        puts "\n[AI] Computer (#{@current_player.color}) is deciding on a move..."
        sleep(1)
        move = @current_player.get_move(@board)

        break if move.nil?
      else
        move = get_human_input
      end

      if move == 'save'
        save_game
        break
      end

      start_pos, end_pos = move
      @board.move_piece(start_pos, end_pos)

      handle_pawn_promotion(end_pos)

      if game_over?
        @board.display
        announce_winner
        delete_save_file
        break
      end

      switch_players
    end
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    
    File.open(SAVE_PATH, 'w') { |file| file.write(YAML.dump(self)) }
    puts "Game successfully saved! Exiting match..."
  end

  def delete_save_file
    if File.exist?(SAVE_PATH)
      File.delete(SAVE_PATH)
      puts "Match completed. Save file cleaned up."
    end
  end

  def game_over?
    checkmate?(@current_player.color) || stalemate?(@current_player.color)
  end

  def checkmate?(color)
    @board.in_check?(color) && total_legal_moves(color).zero?
  end

  def stalemate?(color)
    !@board.in_check?(color) && total_legal_moves(color).zero?
  end

  def announce_winner
    if checkmate?(@current_player.color)
      winner = (@current_player.color == :white) ? 'Black' : 'White'
      puts "\nCheckmate! #{winner} wins the game!"
    elsif  stalemate?(@current_player)
      puts '\nStalemate! The game ends in a draw.'
    end
  end

  private

  def handle_pawn_promotion(end_pos)
    row, col = end_pos
    piece = @board.grid[row][col]
    return unless piece.is_a?(Pawn)

    promotion_row = (piece.color == :white) ? 0 : 7
    return unless row == promotion_row

    if @current_player.is_a?(ComputerPlayer)
      @board.check_promotion(end_pos, Queen)
      puts "\n[AI] Computer promoted its pawn to a Queen!"
    else
      chosen_class = prompt_promotion_choice
      @board.check_promotion(end_pos, chosen_class)
    end
  end

  def prompt_promotion_choice
    loop do
      puts  puts "\nPawn Promotion! Choose a piece: [Q]ueen, [R]ook, [B]ishop, [K]night"
      print 'Selection: '
      choice = gets.chomp.strip.downcase

      case choice
      when 'q', 'queen'   then return Queen
      when 'r', 'rook'    then return Rook
      when 'b', 'bishop'  then return Bishop
      when 'k', 'knight'  then return Knight
      else
        puts 'Invalid choice. Please select a valid piece.'
      end
    end
  end

  def switch_players
    @current_player = (@current_player == @player_white) ? @player_black : @player_white
  end

  def get_human_input
    loop do
      print "\n#{@current_player.color.to_s.capitalize}'s turn. Enter move (e.g., e2e4) or type 'save': "
      input = gets.chomp.strip
      
      return 'save' if input.downcase == 'save'

      parsed = InputParser.parse(input)
      if parsed.nil?
        puts "Invalid input format! Please use structural layouts like 'g1f3'."
        next
      end

      start_pos, end_pos = parsed
      if valid_game_move?(start_pos, end_pos)
        return [start_pos, end_pos]
      else
        puts 'Illegal movement configuration! Select your own pieces or verify King safety bounds.'
      end
    end
  end

  def valid_game_move?(start_pos, end_pos)
    start_row, start_col = start_pos
    piece = @board.grid[start_row][start_col]

    return false if piece.nil?
    return false if piece.color != @current_player.color

    legal_moves = @board.legal_moves_for(piece)
    legal_moves && legal_moves.include?(end_pos)
  end

  def total_legal_moves(color)
    count = 0
    @board.grid.flatten.compact.each do |piece|
      next unless piece.color == color
      moves = @board.legal_moves_for(piece)
      count += moves ? moves.size : 0
    end
    count
  end
end