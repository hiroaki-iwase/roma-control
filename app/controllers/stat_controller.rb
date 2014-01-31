class StatController < ApplicationController
  def index
    require 'socket'
    
    host = ConfigGui::HOST # "10.0.2.15"
    port = ConfigGui::PORT # 10001
    
    @sock = TCPSocket.open(host, port)
    stats_result=[]
    @sock.write("stats\r\n")
    @sock.each{|s|
      break if s == "END\r\n"
      stats_result << s
    }
    @sock.close
    
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
  end

  def update
  end
end
