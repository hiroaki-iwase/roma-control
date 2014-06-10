class ClusterController < ApplicationController

  def index
    roma = Roma.new

    begin
      @stats_hash = roma.get_stats

      @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
      @inactive_routing_list = roma.get_all_routing_list - @active_routing_list

      @routing_info = roma.get_routing_info(@active_routing_list)
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

  def create #[join]
  end

  def destroy #[rbalse|balse]
  end

  def update #[recover]
    roma = Roma.new

    begin
      res = roma.send_command('recover', nil) 
      redirect_to :action => "index"
    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  def release
    host, port = params[:target_instance].split(/_/)
    gon.host = host
    gon.port = port
    roma = Roma.new

    begin
      res = roma.send_command('release', nil, host, port) 
      #redirect_to :action => "index"
      #render :template => "cluster/index", :locals => {:post => @post}

      @stats_hash = roma.get_stats
      @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
      @inactive_routing_list = roma.get_all_routing_list - @active_routing_list
      @routing_info = roma.get_routing_info(@active_routing_list)

      render :action => "index"

    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end
end
