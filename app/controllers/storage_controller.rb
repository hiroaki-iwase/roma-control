class StorageController < ApplicationController
  def index
    roma = Roma.new

    begin
      stats_hash = roma.get_stats
      @run_snapshot = stats_hash["stats"]["run_snapshot"].to_boolean
      @safecopy_stats = roma.change_roma_res_style(stats_hash["storages[roma]"]["storage.safecopy_stats"])
      @last_snapshot_data = stats_hash["stats"]["last_snapshot"]

    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  def data
    #res = Roma.new.set_value("hhh", "yyysdfwefw")
    #render :text => res # debug
  end

end
