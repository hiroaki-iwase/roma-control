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
end
