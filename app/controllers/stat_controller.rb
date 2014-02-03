class StatController < ApplicationController
  def index
    roma = Roma.new
=begin
    @version    = roma.stats_hash["version"]
    @config     = roma.stats_hash["config"]
    @stats      = roma.stats_hash["stats"]
    @storages   = roma.stats_hash["storages[roma]"]
    @wb         = roma.stats_hash["write-behind"]
    @routing    = roma.stats_hash["routing"]
    @connection = roma.stats_hash["connection"]
    @others     = roma.stats_hash["dns_cashe"]
=end
    #render :json => @stats_hash
    #@stats_hash = roma.stats_hash
    @stats_json = roma.stats_json
  end

  def update
  end
end
