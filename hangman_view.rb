require_relative 'display_text'
require 'colored'
require 'terminfo'

class Viewer
  def initialize
    test_term_size
    @lines = 0
  end
  def test_term_size
    @heigth, @with = TermInfo.screen_size
    if @with.to_i < 110 || @heigth.to_i < 36
      puts $bigger_terminal.red
      sleep(0.4)
      test_term_size
    end
    return true
  end
  def clear
    print "\e[2J"
    print "\e[H"
    @lines = 0
  end
  def write_line(text,color)
    lineup_space = '         ' if color
    unless @lines >= @heigth.to_i
      puts "#{print text.center(@with.to_i,' ')}#{lineup_space}"
    end
  end
  def print_line(text, lines = 1, color = true)
    lines.times do
      @lines += 1
      write_line(text,color)
    end
  end
  def find_term_size(size = 2)
    term_size = TermInfo.screen_size
    term_size_part = (term_size[1]/size).to_i
  end
  def home
    clear
    print_line(' ',7,false)
    $home_text.each do |text|
      print_line(text.red)
    end
    print_line(' ',99,false)
    awnser = gets.chomp
    return awnser
  end
  def choose_length
    clear
    print_line("What length do you want your word to be?".green)
    awnser = gets.chomp
    return awnser
  end
  def choose_word
    print_line("What do you want the word to be?".green)
    awnser = gets.chomp
    return awnser
  end
  def print_game(status, word, right_letters, wrong_letters)
    clear
    set_person(status)
    unless status == 0
      print_board
      guessed_letters(right_letters,wrong_letters)
    end
    print_line(word)
    awnser = gets.chomp
    return awnser
  end
  def guessed_letters(right_letters,wrong_letters)
    letters = ('A'..'Z').to_a
    new_letters = []
    letters.each do |letter|
      if right_letters.include?(letter)
        new_letters << letter.green
      elsif wrong_letters.include?(letter)
        new_letters << letter.red
      else
        new_letters << letter.white
      end
    end
    print_line(new_letters.join(" "))
  end
  def finish!(result, word)
    clear
    print_line(' ',3,false)
    13.times do |num|
      print_line("#{$y[num]}     #{$o[num]}     #{$u[num]}".blue)
    end
    print_line(' ',3,false)
    13.times do |num|
      print_line("#{$w[num]}     #{$o[num]}     #{$n[num]}".green) if result == 32
      print_line("#{$l[num]}     #{$o[num]}     #{$s[num]}     #{$e[num]}".red) if result == 31
    end
    print_line(' ',3,false)
    print_line("The word was #{word.join.blue}".green)
    sleep(5)
  end

  def set_person(status)
    $head = 'O'.red
    $left_arm = '_|'.green
    $right_arm = '|_'.green
    $left_leg = '|'.green
    $right_leg = '|'.green
    $body = '|'.green
    $head = 'O'.red if status <= 0
    $left_arm = '  '.red if status <= 1
    $right_arm = '  '.red if status <= 2
    $body = ' '.red if status <= 3
    $left_leg = ' '.red if status <= 4
    $right_leg = ' '.red if status <= 5
  end
  def print_board
    print_line(' ',3,false)
    $hangman.each do |line_in_hangman|
      print_line(line_in_hangman.green)
    end
    print_line(' ',3,false)
  end
end
