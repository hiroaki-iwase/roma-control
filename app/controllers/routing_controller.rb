class RoutingController < ApplicationController
  def index
    roma = Roma.new

    begin
      @stats_hash = roma.get_stats

      @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
      #@inactive_routing_list = roma.get_all_routing_list - @active_routing_list
      #@routing_info = roma.get_routing_info(@active_routing_list)
 
    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  def download
  end
end
