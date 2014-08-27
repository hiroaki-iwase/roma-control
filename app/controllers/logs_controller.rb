class LogsController < ApplicationController
  def index
    session[:ref] = nil
  end

  def show_logs
    if request.path_info != session[:ref]
      session[:ref] = request.path_info
      roma = Roma.new
      stats_hash = roma.get_stats
      active_routing_list = roma.change_roma_res_style(stats_hash["routing"]["nodes"])
      gon.routing_list = active_routing_list.map{|instance|
        self.class.helpers.compact_instance(instance)
      }
      @raw_logs = roma.get_all_logs(active_routing_list)
    else
      redirect_to :action => "index"
    end
  end

  def update
    session[:ref] = nil
    redirect_to :action => "show_logs"
  end

end
