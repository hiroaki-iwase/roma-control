class RoutingController < ApplicationController
  def index
    roma = Roma.new

    begin
      @stats_hash = roma.get_stats
      @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
      @enabled_repetition_in_routingdump = roma.enabled_repetition_in_routingdump?
      @routing_event = roma.get_routing_event

    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  def download
    roma = Roma.new

    begin
      format = params[:format]
      routing_dump = roma.get_routing_dump(format)
      send_data(routing_dump, :filename => "routingdump.#{format}")

    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end
end
