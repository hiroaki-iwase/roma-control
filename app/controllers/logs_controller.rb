class LogsController < ApplicationController
  def index
    roma = Roma.new

    @stats_hash = roma.get_stats
    @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
    gon.routing_list = @active_routing_list.map{|instance|
      self.class.helpers.compact_instance(instance)
    }

    

    @raw_logs = roma.get_all_logs(@active_routing_list)

    #@raw_logs = {}
    #@active_routing_list.each{|instance|
    #  host, port = instance.split("_")
    #  @raw_logs.store(instance, roma.send_command('gather_logs 100', "STARTED", host, port))
    #}

    #@raw_logs
  end

  #def download

  #end
end
