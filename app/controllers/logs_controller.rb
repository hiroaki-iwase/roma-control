class LogsController < ApplicationController
  def index
    roma = Roma.new

    begin
      @stats_hash = roma.get_stats
      @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])

      @raw_logs = {}
      @active_routing_list.each{|instance|
        host, port = instance.split("_")
        @raw_logs.store(instance, roma.send_command('get_logs 100', "END", host, port))
      }
      @raw_logs

    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  def download

  end
end
