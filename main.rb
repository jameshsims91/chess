require_relative 'lib/game'

puts "========================"
puts "       CLI CHESS        "
puts "========================"
puts "1. New Local Game (2 Players)"
puts "2. New Game vs Computer (AI)"
puts "3. Load Saved Game"
print "Select an entry option: "
choice = gets.chomp.strip

case choice
when '3'
  game = Game.load_game
  if game.nil?
    puts "Booting fresh local configuration..."
    game = Game.new(false)
  end
when '2'
  game = Game.new(true) # Pass true for VS Computer AI
else
  game = Game.new(false) # Pass false for Local 2-Player Match
end

game.play