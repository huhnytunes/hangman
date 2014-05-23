require_relative 'hangman_view', 'hangman_model'

class Controller
  def initialize
    @viewer = Viewer.new
    @model = WordBank.new
    @word = Word.new
    run
  end

  def run
    input = @viewer.start_screen
    case input
    when '1'
      game_with_word
    when '2'
      game_with_word_length
    end
  end

  def game_with_word
    word = @viewer.choose_word
    @model.store_word(word)
  end

  def game_with_word_length
    length = @viewer.choose_length
    @model.get_word(length)
  end

  def get_guess
    guess = @viewer.guess

  end

end


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
