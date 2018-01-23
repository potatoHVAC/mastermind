#!/usr/bin/env ruby
require './player.rb'

module Game
  def self.new_game
    puts "Board size? (default 4)"
    size = gets.strip.to_i
    puts "Number of Guesses? (default 20)"
    num = gets.strip.to_i
    [size, num]
  end

  def self.start
    puts "Player name?"
    name = gets.strip
    player = Player.new(name)
    size, num = Game.new_game
    player.new_game(size, num)
    
    while true
      input = gets.strip
      case input
      when 'quit'
        return
      when 'new'
        size, num = Game.new_game
        player.new_game(size, num)
      when 'rand'
        player.rand
      else
        player.guess(input)
      end
    end
  end
end

Game.start
