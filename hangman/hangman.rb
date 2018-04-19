require 'yaml'
require 'json'


module Hangman


  class Player
    attr_accessor :name, :correct_guesses, :incorrect_guesses

    def initialize(name)
      @name = name
      @correct_guesses = []
      @incorrect_guesses = []
    end

    def input
      loop do
        puts
        puts "Please select a letter of the English alphabet"
        puts
        letter = gets.chomp.downcase
        return letter if check_input(letter)
      end
    end

    def check_input(input)
      if ('a'..'z').include?(input) && input.length == 1 && (@correct_guesses+@incorrect_guesses).include?(input) == false
        return true
      end
    end

  end

  class Board

    def initialize(word)
      @word = word
    end

    def print_board(correct_guess,incorrect_guess)
      i=0
      grail_word = @word.split("")
      2.times {puts}
      puts "Word:"
      2.times {puts}
      until i > (grail_word.size-1)
        if correct_guess.include?(grail_word[i])
          print " " + grail_word[i].to_s.upcase + " "
          i+=1
        else
          print " _ "
          i+=1
        end
      end
      2.times {puts}
      puts "Incorrect Guesses: #{incorrect_guess.join(" ").upcase}"
      2.times {puts}
      strikes_left = 9 - incorrect_guess.size
      puts "#{strikes_left} turns left."
      2.times {puts}
    end

  end

  class Game
    attr_accessor :player, :board

    def new_word
      dictionary = File.readlines("5desk.txt")
      words = dictionary.select {|word| word.length.betweem(4,13)}
      word = dictionary[rand(dictionary.size-1)].downcase.strip
    end


    def check_guess(guess)
      if @random_word.split("").include?(guess)
        @player.correct_guesses << guess
      else
        @player.incorrect_guesses << guess
      end
    end

    def check_win?
      word_in_array = @random_word.split("")
      word_in_array.all? {|letter| @player.correct_guesses.include?(letter)}
    end

    def print_full_board
      @board.print_board(@player.correct_guesses,@player.incorrect_guesses)
    end


    def initialize(player)
      @player = Player.new(player)
      @random_word = new_word
      @board = Board.new(@random_word)
      play
    end

    def game_over?
      @player.incorrect_guesses.size == 9
    end


    def play
      puts "Welcome to Hangman!"
      print_full_board
      loop do
        return if save_game?
        if game_over?
          2.times {puts}
          puts "GAME OVER"
          2.times {puts}
          puts "Word was: #{@random_word}"
          return
        else
          player_guess = @player.input
          5.times {puts}
          puts "You have entered #{player_guess.upcase}"
          check_guess(player_guess)
          print_full_board
          if check_win?
            puts "You win!"
            return
          end
        end
      end
    end

    def save_game?
      puts
      puts "Would you like to save the game?"
      puts
      save = gets.downcase
      if save == "yes"
        puts "Please enter filename to save as"
        filename = gets.chomp
        save_game(filename)
      else
        false
      end
    end


    def save_game_json
      self.to_json
    end

    def save_game(filename)
      save_file = File.new(filename + ".json", w )
      save_file.puts save_game_json
      save_file.close
    end


    def self.load(saved_file)
      data = saved_file
      self.new(data['player'], data['random_word'], data['board'])
    end

  end
end

include Hangman
puts "Would you like to load previously saved game?"
reply = gets.chomp.downcase.strip
if reply == "yes"
  puts "Please input file source to load game from"
  file_location = gets.chomp
  saved_file = JSON.load(file_location)
  Game.load(saved_file)
else
  puts "Please enter your name"
  name = gets.chomp
  name = Game.new(name)
end
