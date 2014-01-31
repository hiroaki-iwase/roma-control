class StatController < ApplicationController
  def index
    roma = Roma.new
#=begin
    @version = roma.version
    @config = roma.config
    @stats = roma.stats
    @storages = roma.storages
    @wb = roma.wb
    @routing = roma.routing
    @connection = roma.connection
    @others = roma.others
#=end
  end

  def update
  end
end
