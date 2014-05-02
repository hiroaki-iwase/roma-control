class ClusterController < ApplicationController
  def index
    roma = Roma.new

    begin
      @stats_hash = roma.get_stats

      @active_rlist = @stats_hash["routing"]["nodes"].chomp.delete("\"[]\s").split(",")
      @inactive_rlist = roma.get_all_routing_list - @active_rlist

      @routing_info= roma.get_routing_info(@active_rlist)
      #{
      #  "192.168.223.2_10001"=> {
      #     "status"  => "active", 
      #     "size"    => 209759360, 
      #     "version" => "0.8.14"
      #  },
      #  "192.168.223.2_10002"=> {
      #     "status"  => "active", 
      #     "size"    => 209759360, 
      #     "version" => "0.8.14"
      #  }
      #}

      #render :text => @routing_info
    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  def create
    @test = session[:instance]
  end

  def destroy
    roma = Roma.new
    roma.get_stats
    a = roma.get_instances_list2
    render :text => a
  end

  def update
  end
end
