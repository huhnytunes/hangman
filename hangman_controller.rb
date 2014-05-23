require_relative 'hangman_view', 'hangman_model'

class Controller
  def initialize
    @viewer = Viewer.new
    @model = Words.new
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
  #
end
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
