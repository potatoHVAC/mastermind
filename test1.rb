#!/usr/bin/env ruby
require './main.rb'

test_size = 10
rand_guesses = 5
test_board = Board.new(test_size)
puts "board"
puts test_board


for i in 1..6
  test_guess_solid = []
  test_size.times { test_guess_solid << i }
  puts test_board.make_guess(test_guess_solid)
end


rand_guesses.times do
  test_guess_rand = []
  test_size.times { test_guess_rand << rand(6) }
  
  puts test_board.make_guess(test_guess_rand) 
end


puts "correct"
test_guess_correct = test_board.key.map { |ele| ele = ele.color }
puts test_board.make_guess(test_guess_correct, true)
