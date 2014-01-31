class Roma
  #attr_reader :version, :config, :stats, :storages, :wb, :routing, :connection, :others, :stats_result, :stats_hash
  attr_reader :stats_hash

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


 
=begin
      case res.split(".")[0]
        when "config"
          @stats_hash["config"].store(res.split(".")[1].split(/\s/)[0],res.split(".")[1].split(/\s/)[1])
        when "stats"
          #@stats << res
        when /storages\[.*\]/
          #@storages << res
        when "write-behind"
          #@wb << res
        when "routing"
          #@routing << res
        when "connection"
          #@connection << res
        else
          #@others << res
      end
    }
=end




### [ToDO] convert JSON
=begin
    @version = stats_result.shift
    @config = []
    @stats = []
    @storages = []
    @wb = []
    @routing = []
    @connection = []
    @others = []
    stats_result.each{|res|
      case res.split(".")[0]
        when "config"
          @config << res
        when "stats"
          @stats << res
        when /storages\[.*\]/
          @storages << res
        when "write-behind"
          @wb << res
        when "routing"
          @routing << res
        when "connection"
          @connection << res
        else
          @others << res
      end
    }
=end
  end
end
