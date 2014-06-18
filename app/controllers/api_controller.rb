class ApiController < ApplicationController
  def get_parameter
    host = params[:host]
    port = params[:port]

    begin
      if host && port
        response = Roma.new.get_stats(host, port)
      else
        response = Roma.new.get_stats
      end
    rescue => @ex
      response = {:status=>@ex.message}
    end

    render :json => response
  end

  def get_routing_info
    roma = Roma.new

    begin
      stats_hash = roma.get_stats
      active_routing_list = roma.get_active_routing_list(stats_hash)
      response = roma.get_routing_info(active_routing_list)

    rescue => @ex
      response = {:status=>@ex.message}
    end

    render :json => response
  end
end
