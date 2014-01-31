class Roma
  #attr_reader :version, :config, :stats, :storages, :wb, :routing, :connection, :others, :stats_result
  attr_reader :stats_result

  def initialize
    require 'socket'

    host = ConfigGui::HOST
    port = ConfigGui::PORT

    @sock = TCPSocket.open(host, port)
    @stats_result=[]
    @sock.write("stats\r\n")
    @sock.each{|s|
      break if s == "END\r\n"
      @stats_result << s
    }
    @sock.close

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
