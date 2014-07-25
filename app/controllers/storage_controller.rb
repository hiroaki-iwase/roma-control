class StorageController < ApplicationController
  def index
    roma = Roma.new

    begin
      stats_hash = roma.get_stats

      active_routing_list = roma.change_roma_res_style(stats_hash["routing"]["nodes"])

      # [todo ] change logic
      routing_info = roma.get_routing_info(active_routing_list, 'run_snapshot')
      routing_info.each{|instance, info|
        flash.now[:snapshoting] = instance if info['run_snapshot']
      }
      gon.snapshoting = flash.now[:snapshoting]

      @last_snapshot_data = stats_hash["stats"]["last_snapshot"]
    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  #[toDO] Remove
  def data
  end

end
