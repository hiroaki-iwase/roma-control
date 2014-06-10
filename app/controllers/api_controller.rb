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
    #host = params[:host]
    #port = params[:port]

    roma = Roma.new

    begin
      stats_hash = roma.get_stats
      active_routing_list = roma.change_roma_res_style(stats_hash["routing"]["nodes"])
      response = roma.get_routing_info(active_routing_list)

    rescue => @ex
      response = {:status=>@ex.message}
    end

    render :json => response
  end
end
