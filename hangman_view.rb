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

  def print_line(text, color = true ,lines = 1)
    lines.times do
      @lines += 1
      lineup_space =  '         ' if color
      unless @lines >= TermInfo.screen_size[0]
        puts "#{fill(@mid/2)}#{print (text).center(@mid,' ')}#{fill(@mid/2,lineup_space)}"
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
    print_line(' ',false,7)
    print_line("Welcome to hangman!!".red,)
    print_line("What type if hangman do you wnat to play?".red)
    print_line("1. Play against the computer".green)
    print_line("2. You play against the computer, but can choose the length of the word".green)
    print_line("3. You choose the word".green)
    print_line("".green)
    print_line(' ',false,99)
    awnser = gets.chomps
    return awnser
  end

  def print_game(status, word, right_letters, wrong_letters)
    clear
    @mid = find_term_size
    head,left_arm,right_arm,body,left_leg,right_leg= set_person(status)
    unless status == 0
      print_board(head,left_arm,right_arm,body,left_leg,right_leg)
    end
    awnser = gets.chomp
    return awnser
  end
  def guessed_letters(right_letters,wrong_letters)
    letters = (A..Z).to_a
    print_line(letters)
  end
  def dead(word)
    puts 'Dead'
    puts "word was #{word} "
    #0 =["         xxxxxxxxxx         ","      xxxxx      xxxxx      ","   xxxxx            xxxxx   ","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","xxxxx                  xxxxx","   xxxxx            xxxxx   ","      xxxxx      xxxxx      ","         xxxxxxxxxx         "]
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
view = Viewer.new
view.print_game(0,'g','g','g')
