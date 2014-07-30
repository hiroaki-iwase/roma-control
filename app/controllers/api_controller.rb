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
      response = roma.get_routing_info(active_routing_list, "enabled_repetition_host_in_routing", "short_vnodes")

    rescue => @ex
      response = {:status=>@ex.message}
    end

    render :json => response
  end

  def get_value
    key_name = params[:key]

    begin
      roma = Roma.new
      response = roma.get_value(key_name)[-1]
      response ||= "ERROR: No data"
    rescue => @ex
      response = {:status=>@ex.message}
    end

    render :json => response
  end

  def set_value
    key_name = params[:key]
    value = params[:value]
    expire_time = params[:expire]
    
    begin
      roma = Roma.new('expire_time' => expire_time)

      if roma.valid?
        response = roma.set_value(key_name, value, expire_time)
      else
        roma.errors.full_messages.each { |msg| response = msg }
      end

    rescue => @ex
      response = {:status=>@ex.message}
    end

    render :text => response
  end

end
