class StatController < ApplicationController
  def index
    roma = Roma.new
    @version = roma.stats_result.shift
    @config = []
    @stats = []
    @storages = []
    @wb = []
    @routing = []
    @connection = []
    @others = []
    roma.stats_result.each{|res|
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
=begin
    @version = roma.version
    @config = roma.config
    @stats = roma.stats
    @storages = roma.storages
    @wb = roma.wb
    @routing = roma.routing
    @connection = roma.connection
    @others = roma.others
=end
  end

  def update
  end
end
