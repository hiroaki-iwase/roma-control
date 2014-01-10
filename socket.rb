#!/usr/bin/ruby
require 'socket'

@sock = TCPSocket.open("localhost", 10001)
puts "[[socket start]]\r\n------------------"

@sock.write("stats\r\n")
@sock.each{|s|
  puts s
  break if s == "END\r\n" 
}

puts "-------------\r\n[[socket closing]]"
@sock.close
