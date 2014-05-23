require 'colored'
require 'terminfo'
require 'highline/import'

class Viewer
  def initialize
    @lines = 0
  end
  def clear
    print "\e[2J"
    print "\e[H"
    @lines = 0
  end
  def fill(times, lineup_space= '')
    times.times do
      print ' '
    end
    print lineup_space
    ""
  end

  def print_line(text, color = true, lines = 1)
    half_mid = @mid.to_i/2
    lines.times do
      @lines += 1
      lineup_space =  '         ' if color
      unless @lines >= TermInfo.screen_size[0]
        puts "#{fill(half_mid)}#{print text.center(@mid,' ')}#{fill((half_mid),lineup_space)}"
      end
    end
  end
  def find_term_size
    term_size = TermInfo.screen_size
    term_size_part = term_size[1]/2
  end
  def home
    clear
    @mid = find_term_size
    @mid = @mid.to_i
    print_line(' ',false,7)
    print_line("Welcome to hangman!!".red,)
    print_line("What type if hangman do you wnat to play?".red)
    print_line("1. Play against the computer".green)
    print_line("2. You play against the computer, but can choose the length of the word".green)
    print_line("3. You choose the word".green)
    print_line("".green)
    print_line(' ',false,99)
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
    @mid = find_term_size
    head,left_arm,right_arm,body,left_leg,right_leg = set_person(status)
    unless status == 0
      print_board(head,left_arm,right_arm,body,left_leg,right_leg)
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
    print_line(new_letters.join)
  end
  def dead(word)
    o = ["         xxxxxxxxxx         ","      xxxxx      xxxxx      ","   xxxxx            xxxxx   ","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","   xxxxx            xxxxx   ","      xxxxx      xxxxx      ","         xxxxxxxxxx         "]
    u = ["xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","   xxxxx            xxxxx   ","      xxxxx      xxxxx      ","         xxxxxxxxxx         "]
    y = ["xxxxxx                xxxxxx","  xxxxxx            xxxxxx  ","    xxxxxx        xxxxxx    ","      xxxxxx    xxxxxx      ","        xxxxxxxxxxxx        ","          xxxxxxxx          ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           "]
    l = ["xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx"]
    s = ["xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxx              ","xxxxxxx              ","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","              xxxxxxx","              xxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx"]
    e = ["xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxx              ","xxxxxxx              ","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxx              ","xxxxxxx              ","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx"]
    o.length.times do |num|
      puts "      #{y[num]}     #{o[num]}     #{u[num]}"
    end
    o.length.times do |num|
      puts "#{l[num]}     #{o[num]}     #{s[num]}     #{e[num]}"
    end
    puts "word was #{word.join} "

  end
  def won!(word)
    Puts 'Won'
    puts "You guessed the word #{word}!!"
  end
  def set_person(status)
    head = 'O'.red
    left_arm = '_|'.green
    right_arm = '|_'.green
    left_leg = '|'.green
    right_leg = '|'.green
    body = '|'.green
    left_arm = '  '.red if status <= 1
    right_arm = '  '.red if status <= 2
    body = ' '.red if status <= 3
    left_leg = ' '.red if status <= 4
    right_leg = ' '.red if status <= 5
    return head,left_arm,right_arm,body,left_leg,right_leg
  end
  def print_board(head,left_arm,right_arm,body,left_leg,right_leg)
    print_line(' ',false,3)
    print_line("      xxxxxxxxxxx  ".yellow,true)
    print_line("      x         |  ".yellow,true)
    print_line("      x         |  ".yellow,true)
    print_line("               x         #{head}  ".yellow,true)
    print_line("                        x       #{left_arm} #{right_arm}".yellow,true)
    print_line("               x         #{body}  ".yellow,true)
    print_line("                        x        #{left_leg} #{right_leg} ".yellow,true)
    print_line("      x            ".yellow,true)
    print_line("      x            ".yellow,true)
    print_line("xxxxxxxxxxxxxx     ".yellow,true)
    print_line("x            x     ".yellow,true)
    print_line("x            x     ".yellow,true)
    print_line(' ',false,3)
  end
end
