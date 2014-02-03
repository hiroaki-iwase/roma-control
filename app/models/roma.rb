class Roma
  #attr_reader :version, :config, :stats, :storages, :wb, :routing, :connection, :others, :stats_result, :stats_hash
  attr_reader :stats_hash, :stats_json

  def initialize
    require 'socket'

    host = ConfigGui::HOST
    port = ConfigGui::PORT

    @sock = TCPSocket.open(host, port)
    stats_array = []
    @sock.write("stats\r\n")
    @sock.each{|s|
      break if s == "END\r\n"
      stats_array << s
    }
    @sock.close

    @stats_hash = Hash.new { |hash,key| hash[key] = Hash.new {} }
    stats_array.each{|a|
      key = a.split(/\s/)[0].split(".", 2)
      value = a.split(/\s/)[1]
    
      if key.size == 1
        @stats_hash[key[0]] = value
      else key.size == 2
        @stats_hash[key[0]][key[1]] = value
      end
    }

    @stats_json = ActiveSupport::JSON.encode(@stats_hash)
  end
end
