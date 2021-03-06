require 'colorize'

class Peg
  attr_accessor :color
  
  @@color_list = [:red, :light_blue, :green, :white, :light_magenta, :yellow]
  PEG_SHAPE = "\u25cf"
  
  def initialize(color = nil)
    @color = color
    if @color.nil?
      self.randomize
    elsif color.is_a?(Integer)
      @color = @@color_list[color - 1]
    end
  end

  def to_s
    PEG_SHAPE.colorize(@color)
  end
  
  def self.show_possible
    puts "The possible colors are:"
    @@color_list.each {|c| puts "#{Peg.new(c)} #{c}".colorize(c)}
  end

  def self.fancy_show
    @@color_list.map.with_index do |c, i|
      "#{Peg.new(c)} : #{i + 1}".colorize(c)
    end.join('    ')
  end
    
  def self.add_color_to_list(color)
    @@color_list << color.to_sym
  end

  def self.number_of_colors
    @@color_list.length
  end
  
  def randomize
    @color = @@color_list[rand(@@color_list.length)]
  end
end








class Board

  attr_accessor :key, :key_length, :game_over, :victory
  
  def initialize(key_length = 4, game_length = 20)
    @key_length = key_length
    @game_length = game_length
    @key = []
    self.random_populate
    @key_colors = count_colors(@key)
    @guess_history = []
    @victory = false
    @game_over = false
  end

  def show_game_state
    game_headder.each { |line| puts line }
    @guess_history.each { |guess| puts guess.join(' | ') }
    if @guess_history.length > 0
      game_footer.each { |line| puts line }
    end
  end

  def game_headder
    size_text = " "*(3 - @key_length.to_s.length) + @key_length.to_s
    tries = " "*(3 - @game_length.to_s.length) + @game_length.to_s
    line1 = "---------------------------------------------------------"
    line2 = "|       Board Size:#{size_text}      Number of Guesses:#{tries}       |"
    line3 = ["|  ", Peg.fancy_show, "   |"].join
    output = [line1, line2, line3, line1]
  end

  def game_headder_show
    self.game_headder.each { |line| puts line }
  end
  
  def game_footer_show
    self.game_footer.each { |line| puts line }
  end
  
  def game_footer
      answer = self.to_s
      white_space = " " * ((56 - (@key_length * 2))/2)
      line1 = "---------------------------------------------------------"
      line3 = "|" + white_space + answer + white_space + "|"
    if @victory
      line2 = "|                        Winner!                        |"
      return [line1, line2, line3, line1, ""]
    elsif @game_over
      line2 = "|                        Defeat!                        |"
      return [line1, line2, line3, line1, ""]
    else
      line2 = "|                   Game in Progress                    |"
      return [line1, line2, line1, ""]
    end
  end
      
  
  def random_populate
    @key_length.times do
      element = Peg.new
      element.randomize
      @key << element
    end
  end

  def to_s
    @key.map(&:to_s).join(" ")
  end

  def check_positions(code)
    count = 0
    code.each_with_index do |peg, i|
      if peg.color == @key[i].color
        count += 1
      end
    end
    count
  end

  def check_valid_guess?(num_array, answer = false)
    if answer
      return true
    end
    
    num_array.each do |num|
      if num > Peg.number_of_colors
        return false
      end
    end
    num_array.length == @key_length      
  end

  def count_colors(peg_array)
    colors = Hash.new(0)
    peg_array.each { |peg| colors[peg.color] += 1 }
    colors
  end
    
  
  def check_colors(peg_array)
    count = 0
    guess_colors = count_colors(peg_array)

    guess_colors.each do |color, num|
      if @key_colors[color] != 0
        if  num > @key_colors[color]
          count += @key_colors[color]
        else
          count += num
        end
      end
    end
    count
  end
  
  def check_guess(guess)
    correct_pos = check_positions(guess)
    correct_colors = check_colors(guess)
    
    return [correct_pos, correct_colors]
  end
  
  def make_guess(guess, answer = false)
    if @game_over
      return "game over"
    elsif check_valid_guess?(guess, answer)
      guess.map! { |num| Peg.new(num) }
      pos, col = check_guess(guess)
      update_game_state(pos, col)

      headder = generate_guess_headder
      peg_image = guess.map(&:to_s).join(' ')
      black_peg_image = generate_pegs_arr(pos, :black, true)
      white_peg_image = generate_pegs_arr(col - pos, :white, false)
      
      output = [headder, black_peg_image, peg_image, white_peg_image]
      @guess_history << output
      return output.join(' | ')
    else
      return "not a valid guess"
    end
  end

  
  def random_guess
    arr = []
    @key_length.times { arr << rand(Peg.number_of_colors) + 1 }
    puts self.make_guess(arr)
  end
  
  def generate_guess_headder
    words = "Guess:"
    num = (@guess_history.length + 1).to_s
    words + ' ' * (3 - num.length) +  num
  end
  
  def generate_pegs_arr(num, color, reverse)
    if num < 0
      num = 0
    end
    
    blank_space = Array.new(@key_length - num, " ")
    color_peg = Peg.new(color).to_s
    peg_arr = Array.new(num, color_peg)
    if reverse
      return (blank_space + peg_arr).join(' ')
    end
    
    output = (peg_arr + blank_space).join(" ")
  end
  
  def update_game_state(pos, col)
    if @key_length == pos && @key_length == col
      @victory = true
      @game_over = true
    end
    if @guess_history.length >= @game_length - 1
      @game_over = true
    end
  end
end


