require 'colored'
require 'terminfo'

class Viewer
  def initialize
    @lines = 0

  end
  def clear
    print "\e[2J"
    print "\e[H"
    @lines = 0
  end
  def fill(times)
    times.times do
      print '*'
    end
    ""
  end

  def print_line(text, mid, color = true ,lines = 1)
    lines.times do
      @lines += 1
      unless @lines >= TermInfo.screen_size[0]
        puts "#{fill(mid/2)}#{print text.center(mid,' ')}#{fill(mid/2)}"
      end
    end
  end
  def find_term_size
    term_size = TermInfo.screen_size
    term_size_part = term_size[1]/2
  end
  def home
    mid = find_term_size
    full = 2*(mid/2)+mid
    clear
    print_line('*',mid,7)
    print_line("Welcome to hangman!!".red, mid)
    print_line("What type if hangman do you wnat to play?".red,mid)
    print_line("1. Play against the computer".green,mid)
    print_line("2. You play against the computer, but can choose the length of the word".green,mid)
    print_line("3. You choose the word".green,mid)

  end

  def new_game_rand


  end


  def new_game_custom


  end

end
view = Viewer.new
view.home
