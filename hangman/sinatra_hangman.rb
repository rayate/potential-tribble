require 'sinatra'
enable :sessions
class Hangman
  attr_accessor :word, :correct_guesses, :incorrect_guesses, :board

  def initialize
    @word = new_word
    @correct_guesses = []
    @incorrect_guesses = []
    @board = []
  end

  def turns_left
    7 - @incorrect_guesses.size
  end


  def print_board
    i=0
    @board = []
    until i > @word.size-1
      if @correct_guesses.include?(@word[i])
        @board << @word[i].upcase
      else
        @board << "_"
      end
      i+=1
    end
  end

  def new_word
    dictionary = File.readlines("5desk.txt")
    words = dictionary.select {|word| word.length.between?(4,13)}
    word = dictionary[rand(dictionary.size-1)].downcase.strip
  end

  def guess_valid?(guess)
    ("a".."z").include?(guess) && !@incorrect_guesses.include?(guess)
  end

  def check_guess(guess)
    return if guess_valid?(guess) == false
    if @word.split("").include?(guess)
      @correct_guesses << guess
    else
      @incorrect_guesses << guess
    end
  end

  def check_win?
    word_in_array = @word.split("")
    word_in_array.all? {|letter| correct_guesses.include?(letter)}
  end

  def game_over?
    return "You win!" if check_win?
    return "You lose!" if turns_left == 0
    false
  end


end



game = nil


get '/' do
  game = Hangman.new
  game.print_board
  print_board = game.board
  game_over = game.check_win?
  turns_left = game.turns_left
  incorrect_guesses = game.incorrect_guesses
  erb :index, :locals => {:incorrect_guesses => incorrect_guesses, :print_board => print_board, :turns_left => turns_left}
end

post '/' do
  guess = params['guess']
  game.check_guess(guess)
  game.print_board
  print_board = game.board
  turns_left = game.turns_left
  incorrect_guesses = game.incorrect_guesses
  redirect '/gameover' if game.game_over?
  erb :index, :locals => {:incorrect_guesses => incorrect_guesses,  :print_board => print_board,  :turns_left => turns_left}
end

get '/gameover' do
  game_over = game.game_over?
  word = game.word
  erb :game_over, :locals => {:game_over => game_over, :word => word}
end

post '/gameover' do
  new_game = params['new_game'].downcase.strip
  redirect '/' if new_game == "yes"
end
