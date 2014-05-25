require_relative 'display_text'
require 'colored'
require 'terminfo'

class Viewer
  def initialize
    test_term_size
    @lines = 0
  end
  def color (color=rand(31..36))
    printf "\033[#{color}m";
    yield
    printf "\033[0m"
  end
  def test_term_size
    @heigth, @with = TermInfo.screen_size
    if @with.to_i < 110 || @heigth.to_i < 36
      puts $bigger_terminal.red
      sleep(0.5)
      test_term_size
    end
    return true
  end
  def clear
    print "\e[2J"
    print "\e[H"
    @lines = 0
  end
  def write_line(text)
    unless @lines >= @heigth.to_i
      color {puts "#{text.center(@with.to_i,' ')}"}
    end
  end
  def print_line(text, lines = 1)
    test_term_size
    lines.times do
      @lines += 1
      write_line(text)
    end
  end
  def home
    clear
    print_line(' ',7)
    $home_text.each do |text|
      print_line(text)
    end
    print_line(' ',99)
    awnser = $stdin.gets.chomp
    return awnser
  end
  def online_mode(users_online)
    clear
    print_line(' ',2)
    if users_online.length != 0
    print_line("This is the users online:".green)
      users_online.each do |user|
        print_line("#{user[0]}  status:  #{user[1]}".yellow)
      end
    else
      print_line("There is no users online".yellow)
      print_line(' ',2)
    end
    print_line(' ',2)
    $online_mode_text.each do |text|
      print_line(text.red)
    end
    print_line(' ',99)
    awnser = $stdin.gets.chomp
    return awnser
  end
  def choose_length
    clear
    print_line($what_length.yellow)
    awnser = gets.chomp
    return awnser
  end
  def choose_word
    clear
    print_line("What do you want the word to be?".yellow)
    awnser = gets.chomp
    return awnser
  end
  def print_game(status, word, right_letters, wrong_letters, msg = "")
    clear
    print_line(msg)
    print_board(status)
    guessed_letters(right_letters,wrong_letters)
    print_line(word.split('').join(' ').to_s)
    print_line(' ',99)
    return gets.chomp
  end
  def guessed_letters(right_letters,wrong_letters)
    letters = ('A'..'Z').to_a
    print " " * (@with/2 - 26)
    letters.each do |letter|
      if right_letters.include?(letter)
        print letter.green + " "
      elsif wrong_letters.include?(letter)
        print letter.red + " "
      else
        print letter.white + " "
      end
    end
    print "\n"
  end
  def finish!(result, word)
    100.times do |times_num|
      clear
      print_line(' ',3)
      13.times do |num|
        print_line("#{$y[num]}     #{$o[num]}     #{$u[num]}")
      end
      print_line(' ',3)
      13.times do |num|
        print_line("#{$w[num]}     #{$o[num]}     #{$n[num]}") if result == 32
        print_line("#{$l[num]}     #{$o[num]}     #{$s[num]}     #{$e[num]}") if result == 31
      end
      print_line(' ',3)
      print_line("The word was #{word.join.blue}")
      sleep(0.1)
    end
  end

  def set_person(status,body)
    body[0] = 'O'.red if status <= 5
    body[1] = '_|'.red if status <= 4
    body[2] = '|_'.red if status <= 3
    body[3] = '|'.red if status <= 2
    body[4] = '|'.red if status <= 1
    body[5] = '|'.red if status <= 0
    body
  end
  def print_board(status)
    body = [' '.red,'  '.red,'  '.red,' '.red,' '.red,' '.red]
    body = set_person(status,body)
    hangman = ["      xxxxxxxxxxx  \r","      x         |  \r","      x         |  \r","               x         #{body[0]}  \r","                        x       #{body[1]} #{body[2]}\r","               x         #{body[3]}  \r","                        x        #{body[4]} #{body[5]} \r","      x            \r","      x            \r","xxxxxxxxxxxxxx     \r","x            x     \r","x            x     \r"]
    print_line(" \r",3)
    hangman.each do |line_in_hangman|
      print_line("         "+line_in_hangman)
    end
    print_line(" \r",3)
  end
end
