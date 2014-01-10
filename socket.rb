#!/usr/bin/ruby
require 'socket'

host = if ARGV[0] then ARGV[0] else 'localhost' end
port = if ARGV[1] then ARGV[1] else '10001' end
@sock = TCPSocket.open(host, port)

puts "[[socket start]]\r\n------------------"

@sock.write("stats\r\n")
@sock.each{|s|
  puts s
  break if s == "END\r\n" 
}

puts "-------------\r\n[[socket closing]]"
@sock.close
