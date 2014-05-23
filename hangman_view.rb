require 'colored'
require 'terminfo'
require 'highline/import'

class Viewer
  def initialize
    if TermInfo.screen_size[1].to_i < 110 ||TermInfo.screen_size[0].to_i < 36
      puts "MAKE YOUR TERMINAL BIGGER!!!".red
      sleep(10)
      exit
    end
    @lines = 0
    @o = ["         xxxxxxxxxx         ","      xxxxx      xxxxx      ","   xxxxx            xxxxx   ","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","   xxxxx            xxxxx   ","      xxxxx      xxxxx      ","         xxxxxxxxxx         "]
    @u = ["xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","   xxxxx            xxxxx   ","      xxxxx      xxxxx      ","         xxxxxxxxxx         "]
    @y = ["xxxxxx                xxxxxx","  xxxxxx            xxxxxx  ","    xxxxxx        xxxxxx    ","      xxxxxx    xxxxxx      ","        xxxxxxxxxxxx        ","          xxxxxxxx          ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           ","           xxxxxx           "]
    @l = ["xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxx              ","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx"]
    @s = ["xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxx              ","xxxxxxx              ","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","              xxxxxxx","              xxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx"]
    @e = ["xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxx              ","xxxxxxx              ","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxx              ","xxxxxxx              ","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx","xxxxxxxxxxxxxxxxxxxxx"]
    @w = ["xxxxxxx            xxxxxxxxx            xxxxxxx","xxxxxxx            xxxxxxxxx            xxxxxxx"," xxxxxxx          xxxxxxxxxxx          xxxxxxx "," xxxxxxx          xxxxxxxxxxx          xxxxxxx ","  xxxxxxx        xxxxxxxxxxxxx        xxxxxxx  ","  xxxxxxx        xxxxxxxxxxxxx        xxxxxxx  ","   xxxxxxx      xxxxxxx xxxxxxx      xxxxxxx   ","   xxxxxxx      xxxxxxx xxxxxxx      xxxxxxx   ","    xxxxxxx    xxxxxxx   xxxxxxx    xxxxxxx    ","    xxxxxxx    xxxxxxx   xxxxxxx    xxxxxxx    ","     xxxxxxx  xxxxxxx     xxxxxxx  xxxxxxx     ","      xxxxxxxxxxxxxx       xxxxxxxxxxxxxx      ","       xxxxxxxxxxxx         xxxxxxxxxxxx       "]
    @n = ["xxxxxxx          xxxx","xxxxxxxx         xxxx","xxxxxxxxx        xxxx","xxxx xxxxx       xxxx","xxxx  xxxxx      xxxx","xxxx   xxxxx     xxxx","xxxx    xxxxx    xxxx","xxxx     xxxxx   xxxx","xxxx      xxxxx  xxxx","xxxx       xxxxx xxxx","xxxx        xxxxxxxxx","xxxx         xxxxxxxx","xxxx          xxxxxxx"]
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

  def print_line(text, color = true, lines = 1, set_space = 6)
    mid = TermInfo.screen_size[1].to_i
    half_set = mid.to_i/set_space
    mid_rest = TermInfo.screen_size[1].to_i - half_set*2
    lines.times do
      @lines += 1
      lineup_space =  '         ' if color
      unless @lines >= TermInfo.screen_size[0].to_i
        puts "#{fill(half_set)}#{print text.center(mid_rest,' ')}#{fill((half_set),lineup_space)}"
      end
    end
  end
  def find_term_size(size = 2)
    term_size = TermInfo.screen_size
    term_size_part = (term_size[1]/size).to_i
  end
  def home
    clear
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
    clear
    print_line(' ',false,3)
    @o.length.times do |num|
      print_line("#{@y[num]}     #{@o[num]}     #{@u[num]}".red)
    end
    print_line(' ',false,3)
    @o.length.times do |num|
      print_line("#{@l[num]}     #{@o[num]}     #{@s[num]}     #{@e[num]}".red)
    end
    print_line(' ',false,3)
    print_line("The word was #{word.join.blue}".green)
    sleep(5)
  end
  def won!(word)
    clear
    print_line(' ',false,3)
    @o.length.times do |num|
      print_line("#{@y[num]}     #{@o[num]}     #{@u[num]}".green)
    end
    print_line(' ',false,3)
    @o.length.times do |num|
      print_line("#{@w[num]}     #{@o[num]}     #{@n[num]}".green)
    end
    print_line(' ',false,3)
    print_line("The word was #{word.join.blue}".green)
    sleep(5)
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
