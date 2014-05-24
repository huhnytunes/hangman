require_relative 'hangman_view'
require_relative 'hangman_model'
class Controller
  attr_accessor :word
  def initialize
    @viewer = Viewer.new
    @model = WordBank.new
    @letter_bank = LetterBank.new
    choose_game_type
  end

  def choose_game_type
    input = @viewer.home
    case input
    when '1'
      get_random_word
    when '2'
      get_word_with_length
    when '3'
      get_word_from_user
    end
  end

  def get_random_word
    @word = Word.new(@model.random_word)
    get_status
  end

  def get_word_with_length
    length = @viewer.choose_length
    @word = Word.new(@model.get_word(length))
    get_status
  end

  def get_word_from_user
    @word = Word.new(@viewer.choose_word)
    get_status
  end


  def get_status
    @status = 6
    if print_board(@word.current_word)
      @viewer.finish!(32, @word.target_word)
    else
      @viewer.finish!(31, @word.target_word)
    end
    @viewer.home
  end

  def print_board(word_filled)
    return false if dead?
    return true if won?(word_filled)
    guess = @viewer.print_game(@status, word_filled.join, @letter_bank.correct_letters, @letter_bank.incorrect_letters)
    guess = guess.upcase
    word_filled = @word.check_word(guess)
    if @word.is_correct?(guess)
      @letter_bank.add_correct(guess)
    else
      @letter_bank.add_incorrect(guess)
      @status -= 1
    end
    print_board(word_filled)
  end

  def dead?
    true if @status == 0
  end

  def won?(word_filled)
    true if word_filled.join == @word.target_word.join
  end
end

# DRIVER
Controller.new

