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
    print "\e[2J"
    print "\e[H"
  end
	def initialize(server, port, nick, channel)
		@server = server
		@port = port
		@nick = nick
		@right_nick = false
		@channel = channel
		connect
	end
	def say(s)
		#puts "--> #{s}"
		@irc.puts "#{s}"
	end
 	def say_c(msg)
    say "PRIVMSG ##{@channel} :#{msg}"
  end
  def send(msg)
		if msg == LIST
      list_users
     else
     	say_c(msg)
     end

  end
  def change_nick
		say("WHO #{@nick}")
		lines = []
		until @right_nick
			ret = @irc.gets
			lines << ret.split(" ")[1]
			if ret.match(" :End of /WHO list.")
				if lines.include?("352")
					clear
					color{puts "You can not use that nickname, it is probably someone else that is using it right now...."}
					color{puts "Choose a new nick name"}
					@nick = gets.chomp
					change_nick
				else
					say("NICK #{@nick}")
					@right_nick = true
				end
			end
		end
  end
	def connect
		@irc = TCPSocket.open(@server, @port)
		nick = "Bot#{rand(100_000_000_000).to_s}"
		say "USER #{nick} 0 * #{nick}"
		say "NICK #{nick}"
		@eof = @irc.eof
	end
	def join
		say "JOIN ##{@channel}"
		say_c "Logged in"
	end
	def list_users
		say("WHO ##{@channel}")
		lines = []
	 	stop = false
	 	pust "starting"
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
	def run
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
end
print "\e[2J"
print "\e[H"
ip = 'chat.freenode.net'
port = 6667
puts "What nickname do you want to use?"
nick = gets.chomp
channel = 'dbc'
irc = IRC.new(ip, port, nick, channel)
irc.change_nick
irc.join
recive_irc = Thread.new {irc.run}
send_irc = Thread.new do
	until irc.eof { irc.send(gets.chomp) }
end
print "\e[2J"
print "\e[H"
puts "You have logged in succsessfully :D"
puts "you can start your message with LIST to see who else is in the chat."
recive_irc.join
send_irc.join