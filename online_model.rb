require "socket"
class Chat
  def initialize(server, port, nick='not_set')
    @server = server
    @port = port
    @nick = nick
    @right_nick = false
    @channel = 'dbc'
    @channel_game = 'dbc_hangman'
    @channel_chat = 'dbc_chat'
  end
  def color (color=rand(31..36))
    printf "\033[#{color}m";
    yield
    printf "\033[0m"
  end
  def clear
#    print "\e[2J"
#    print "\e[H"
  end
  def say(s)
    #puts "--> #{s}"
    @irc.puts "#{s}"
  end
  def say_c(msg)
    say "PRIVMSG ##{@channel_chat} :#{msg}"
  end
  def say_g(msg)
    say "PRIVMSG ##{@channel_game} :#{msg}"
  end
  def send(msg)
    if msg == 'LIST'
      list_users(@channel_chat)
    elsif msg == 'QUIT'
      quit
     else
      say_c(msg)
     end

  end
  def get_new_nick(new_nick=false)
    clear
    if new_nick
      color{puts "You can not use that nickname, it is probably someone else that is using it right now...."}
      color{puts "Choose a new nick name"}
    else
      color{puts "What nick do you want?"}
    end
    @nick = gets.chomp
    @right_nick = false
    change_nick
  end
  def change_nick
    color{puts "Verifying nickname"}
    say("WHO #{@nick}")
    lines = []
    until @right_nick
      ret = @irc.gets
      lines << ret.split(" ")[1]
      if ret.match(" :End of /WHO list.")
        if lines.include?("352")
          get_new_nick(true)
        else
          say("NICK #{@nick}")
          clear
          color{puts "Nick verifyed"}
          @right_nick = true
        end
      end
    end
  end
  def connect
    color{puts "Connecting to server..."}
    @irc = TCPSocket.open(@server, @port)
    @user = "Bot#{rand(100_000_000_000).to_s}"
    say "USER #{@user} 0 * #{@user}"
    say "NICK #{@user}"
    @eof = @irc.eof
  end
  def connect_check
    connected = false
    until connected
      ret = @irc.gets
      if ret.match(" :End of /MOTD command.")
        color{puts "You are now connected to the server :)"}
        connected = true
      end
    end
  end
  def join
    say "JOIN ##{@channel}"
  end
  def join_chat
    say "JOIN ##{@channel_chat}"
    say_c "I have logged in with the nick #{@nick}"
    clear
    sleep(1)
    list_users(@channel_chat)
    color(33){puts "you can start your message with LIST to see who else is in the chat."}
  end
  def list_all_users
    users = []
    channels = [@channel,@channel_chat,@channel_game]
    status = ["waiting for game","In Chat","In Game"]
    3.times do |number|
      say("WHO ##{channels[number]}")
      stop = false
      until stop
        ret = @irc.gets
        ret_a = ret.split(" ")
        if ret.match(" :End of /WHO list.")
          stop = true
        elsif ret_a[1] == "352" && ret_a[7] != 'ChanServ' && ret_a[7] != @nick
          if number != 0
            users.each_with_index do |user, index|
              if user[0] == ret_a[7]
                users[index] == [ret_a[7],status[number]]
              end
            end
          else
            users << [ret_a[7],status[number]]
          end
        end
      end
    end
    p users
    return users
  end
  def list_users(channel)
    say("WHO ##{channel}")
    lines = []
    users = []
    stop = false
    until stop
      ret = @irc.gets
      ret_a = ret.split(" ")
      if ret.match(" :End of /WHO list.")
        stop = true
        print_users(users)
      elsif ret_a[1] == "352" && ret_a[7] != 'ChanServ' && ret_a[7] != @nick
        users << ret_a[7]
      end
    end
  end
  def print_users(users)
    color(36){puts "#" * 100}
    color(36){puts "there is #{users.length+1} users online in the chat"}
    color(36){puts "This is the online users:"}
    color(33){puts "#{@nick}(you)"}
    users.each{|user|color(32){puts user}}
    color(36){puts "#" * 100}
  end
  def get_chat
    until @irc.eof do
      full_msg = @irc.gets
      if full_msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end
      if full_msg.match(/PRIVMSG ##{@channel_chat} :(.*)$/)
        msg = $~[1]
        nick = (full_msg.split(/!/)[0])[1..-1]
        if full_msg.match("I have logged in with the ")
          color(31){puts "#{nick} have logged in!"}
        elsif full_msg.match("I am leaving the chat now!")
          color(31){puts "#{nick} have left the chat!"}
        else
          color(32){puts "#{nick} ==> #{msg}"}
        end
      end
    end
  end
  def quit
    say_c "I am leaving the chat now!"
    say "PART ##{@channel_game} Leaving..."
    say "PART ##{@channel_chat} Leaving..."
    say "PART ##{@channel} Leaving..."
    say 'QUIT'
    @eof = true
  end
  def login
    clear
    connect
    connect_check
    get_new_nick
    join
  end
  def chat
    join_chat
    recive_irc = Thread.new {get_chat}
    send_irc = Thread.new do
      until @eof do
        send(gets.chomp)
      end
    end
    recive_irc.join
    send_irc.join
  end
end
