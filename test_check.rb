#!/usr/bin/env ruby
require './main.rb'

test_len = 5
test_board = Board.new(test_len)
puts test_board

puts "number of colors #{Peg.number_of_colors}"
puts test_board.make_guess([1,2,1,6,4])
puts test_board.make_guess([1,2,1,6,7])
puts test_board.make_guess([1,2,1])
puts test_board.make_guess([1,1,1,1,1])
puts test_board.make_guess([3,3,1,5,5])
puts test_board.make_guess([5,5,1,6,5])

