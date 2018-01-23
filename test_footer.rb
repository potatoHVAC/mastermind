require './main.rb'


test = Board.new(2)
test.show_game_state
2.times { puts test.random_guess }
test.show_game_state

test_guess_correct = test.key.map { |ele| ele = ele.color }
puts test.make_guess(test_guess_correct, true)
test.show_game_state
