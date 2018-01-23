require './pieces.rb'

class Player

  attr_reader :name, :victories, :defeats
  
  def initialize(name)
    @name = name
    @active_game = nil
    @victories = []
    @defeats = []
  end


  def new_game(size = 4, length = 20)
    if @active_game
      puts "active game in progress"
    else
      if size == 0
        size = 4
      end
      if length == 0
        length = 20
      end
      @active_game = Board.new(size, length)
      @active_game.show_game_state
    end
  end

  def guess(input)
    if input.is_a?(String)
      input = input.split('').map(&:to_i)
    end
    if @active_game
      puts @active_game.make_guess(input)
      
      if @active_game.victory
        @victories << @active_game
        @active_game.game_footer_show
        @active_game = nil
      elsif @active_game.game_over
        @defeats << @active_game
        @active_game.game_footer_show
        @active_game = nil
      end
    else
      puts "No active game"
    end
  end

  def rand
    @active_game.random_guess
  end
end
  
