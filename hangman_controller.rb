require_relative 'hangman_view', 'hangman_model'

class Controller
  attr_accessor :word
  def initialize
    @viewer = Viewer.new
    @model = WordBank.new
    @word = ''
    # @word_filled = '_'
    @right_guesses = []
    @wrong_guesses = []
    @status = @word.length
    choose_game_type
  end

  def choose_game_type
    input = @viewer.home
    case input
    when '1'
      game_with_random_word
    when '2'
      game_with_word_length
    when '3'
      game_with_word
    end
  end

  def get_random_word
    @word = @model.random_word
    get_word_length(@word)
  end

  def get_word_with_length
    length = @viewer.choose_length
    @word = @model.get_word(length)
    set_blank_word_with_spaces(length)
  end

  def get_word_from_user
    @word = @viewer.choose_word
    get_word_length(@word)
  end

  def get_word_length(word)
    length = word.length
    set_blank_word_with_spaces(length)
  end

  def set_blank_word_with_spaces(length)
    @word_filled = @word_filled*length
  end

  def get_status
    @status = 6
    if print_board
      @viewer.won
    else
      @viewer.dead
    end
  end

  def print_board(word_filled)
    return false if dead?
    return true if won?(word_filled)
    guess = @viewer.print_game(status, word_filled.join, @right_guesses, @wrong_guesses)
    guess = guess.upcase
    word_filled = @model.check_word(guess)
    if @midel.is_right(guess)
      @right_guesses << guess
    else
      @wrong_guesses << guess
      @status -= 1
    end
    print_board(word_filled)
  end

  # def fill_word(letter_indexes)
  #   if letter_indexes.length > 0
  #     @word_filled.each_with_index do |i, e|
  #       @word_filled[letter_indexes]

  def dead?
    true if @status = 0
  end

  def won?(word_filled)
    true if word_filled.join.upcase == @model.word.upcase
  end
end

# DRIVER



# @viewer.print_board(status = 6, word_with_spaces)
  # def game_with_word
  #   @word = @viewer.choose_word # downcase?
  #   @viewer.print_board
  # end

  # def game_with_word_length
  #   length = @viewer.choose_length
  #   @model.get_word(length)
  #   @viewer.print_board(status, word_with_spaces, used_letters, wrong_letters)
  # end







#   def get_guess
#     guess = @viewer.guess
#     check_guess(guess)
#   end

#   def check_guess(guess)
#     @model.check_guess
#   end

#   def fill_word
#   end

#   def fill_guess_bank
#   end

#   def show_man # new / current ??
#     @viewer.show_man
#   end


# end

# DRIVER

# controller = Controller.new



  # letter is in the word( true/false)
  # new_game
  # grab_word
  # show_man
  # show_empty_word
  # grab_letter
  # check_letter
  # => if right, fill_word
  # => if wrong, add to array of wrong letters

##Controller(only returns word as string)
# new_game(word_lenght)[not return]
# current_word()[return current word with spaces as hidden letters]
# check_guess?(letter)[true/false]
# is_finished? [true/false]

#make a new model that gives a random word

##viewer
#start page(with new random game/ new game with own word/ new game with own length)
# recursive loop with the guess bank / current man / current word
#
##model
#read the words form the file
#
