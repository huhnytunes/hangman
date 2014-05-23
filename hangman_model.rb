class WordBank
  def initialize
    load_words
  end

  def load_words
    @word_hash = {}
    File.read('word_bank.csv').each_line do |word|
      word_length = word.chomp.size
      @word_hash[word_length].is_a?(Array) ? @word_hash[word_length] << word.chomp : @word_hash[word_length] = [word.chomp]
    end
  end

  def get_word(size)
    @word_hash[size].sample.upcase
  end

  def random_word
    get_word(rand(4..24))
  end
end

class Word
  attr_reader :target_word, :current_word
  def initialize(word)
    @target_word = word.upcase.split('')
    @current_word = []
    @target_word.length.times {@current_word << "_"}
  end

  def check_word(letter)
    letter.upcase!
    indices = []
    @target_word.each_with_index{|space, index| indices << index if space == letter}
    indices.each {|index|@current_word[index] = @target_word[index]}
    @current_word
  end

  def is_correct?(letter)
    letter.upcase!
    @target_word.include? letter
  end
end

class LetterBank
  attr_reader :correct_letters, :incorrect_letters
  def initialize
    @correct_letters = []
    @incorrect_letters = []
  end

  def add_correct(letter)
    @correct_letters << letter
  end

  def add_incorrect(letter)
    @incorrect_letters << letter
  end
end
