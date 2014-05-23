class WordBank
  attr_reader :word_array
  def initialize
    @word_array = []
    load_words
  end

  def load_words
    @words = File.open('word_bank.csv')
    @words.each_line do |word|
      @word_array << word.chomp
    end
    @words.close
    csv_to_hash
  end

  def csv_to_hash
    @word_hash = {}
    @word_array.each do |word|
      word_length = word.size              # "gyne" => word
      if @word_hash[word_length].is_a?(Array)
        @word_hash[word_length] << word
      else
        @word_hash[word_length] = [word]
      end
    end
  end

  def get_word(size)
    @word_hash[size].sample
  end

  def random_word
    get_word(rand(4..24))
  end
end

words = WordBank.new
p words.random_word
# words.load_words
# p words.word_array
#p words.random_word
