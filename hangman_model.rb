class WordBank
  attr_reader :word_array
  def initialize
    @word_array = []
    load_words
  end

  def load_words
    @words = File.open('dictionary.txt')
    @words.each_line do |word|
      @word_array << word.chomp
    end
    @words.close
    write_words
  end

  def write_words
    @word_array = @word_array.sort_by {|word| word.length}
    @new_list = File.open('word_bank.csv', 'w')
    @word_array.each do |word|
      @new_list.write("#{word}\n")
    end
    @new_list.close
  end
end
#   def random_word(size = 2)
#     word = ""
#     until word.length >= size
#       word << @word_array.sample
#     end
#     word
#   end
# end

words = WordBank.new

# words.load_words
# p words.word_array
# p words.random_word
