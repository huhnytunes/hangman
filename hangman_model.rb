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
    @word_hash[size].sample.downcase
  end

  def random_word
    get_word(rand(4..24))
  end
end
