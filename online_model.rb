require "socket"
$SAFE=1
class IRC
	attr_accessor :eof
	def color (color=rand(31..36))
    printf "\033[#{color}m";
    yield
    printf "\033[0m"
  end
  def clear
    #print "\e[2J"
    #print "\e[H"
  end
	def initialize(server, port, channel, nick='not_set')
		@server = server
		@port = port
		@nick = nick
		@right_nick = false
		@channel = channel
		login
	end
	def say(s)
		#puts "--> #{s}"
		@irc.puts "#{s}"
	end
 	def say_c(msg)
    say "PRIVMSG ##{@channel} :#{msg}"
  end
  def send(msg)
		if msg == 'LIST'
      puts 'yes'
      list_users
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
		say_c "I have logged in with the username #{@user} and the nick #{@nick}"
    clear
    color{puts "you can start your message with LIST to see who else is in the chat."}
	end
	def list_users
    color{puts "starting"}
		say("WHO ##{@channel}")
		lines = []
	 	stop = false
		until stop
			ret = @irc.gets
			puts ret
			#lines << ret.split(" ")[1]
			#if ret.match(" :End of /WHO list.")
			#	if lines.include?("352")
			#		clear
			#		color{puts "You can not use that nickname, it is probably someone else that is using it right now...."}
			#		color{puts "Choose a new nick name"}
			#		@nick = gets.chomp
			#		change_nick
			#	else
			#		say("NICK #{@nick}")
			#		@right_nick = true
			#	end
			#end
		end
	end
	def get
		until @irc.eof do
			full_msg = @irc.gets
			if full_msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end
			if full_msg.match(/PRIVMSG ##{@channel} :(.*)$/)
        msg = $~[1]
				nick = (full_msg.split(/!/)[0])[1..-1]
    		color{puts "#{nick} ==> #{msg}"}
    	end
		end
	end
	def quit
    say "PART ##{@channel} Leaving..."
    say 'QUIT'
  end
  def login
    connect
    connect_check
    get_new_nick
    join
    chat
  end
  def chat
    recive_irc = Thread.new {get}
    send_irc = Thread.new do
      until @eof do
        send(gets.chomp)
      end
    end
    recive_irc.join
    send_irc.join
  end
end
IRC.new('chat.freenode.net', 6667, 'dbc')
