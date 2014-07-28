class ClusterController < ApplicationController

  def index
    roma = Roma.new

    @stats_hash = roma.get_stats

    @active_routing_list = roma.change_roma_res_style(@stats_hash["routing"]["nodes"])
    @inactive_routing_list = roma.get_all_routing_list - @active_routing_list
    @routing_info = roma.get_routing_info(@active_routing_list)
    # [toDO] Remove before release
    #{
    #  "192.168.223.2_10001"=> {
    #     "status"  => "active", 
    #     "size"    => 209759360, 
    #     "version" => "0.8.14",
    #     "primary_nodes" => "171",
    #     "secondary_nodes" => "170",
    #  },
    #  "192.168.223.2_10002"=> {
    #     "status"  => "active", 
    #     "size"    => 209759360, 
    #     "version" => "0.8.14",
    #     "primary_nodes" => "170",
    #     "secondary_nodes" => "169",
    #  }
    #}

    @routing_info.each_key{|instance|
      if instance =~ /ERROR/
        gon.just_booting = true
        break
      else
        gon.just_booting = false
      end
    }

    @routing_info.each{|instance, info|
      flash.now[:unknown] = instance if info.has_value?("unknown")
      case info["status"]
      when "release"
        gon.host, gon.port = instance.split(/_/) 
        # in case of release was executing by console or login by other users
        if !session[:denominator]
          session[:denominator] = info["primary_nodes"] + info["secondary_nodes"]
        end
        gon.denominator = session[:denominator]
        gon.routing_info = @routing_info
      when "join"
        gon.host, gon.port = instance.split(/_/)
        gon.routing_info = @routing_info
      when "recover"
        gon.host, gon.port = instance.split(/_/) 
        if !session[:denominator]
          session[:denominator] = @stats_hash["routing"]["short_vnodes"]
        end
        gon.denominator = session[:denominator]
        gon.routing_info = @routing_info
      end
    }
  end

  def destroy #[rbalse]
    host, port = params[:target_instance].split(/_/)
    roma = Roma.new

    if session[:released]
      if session[:released] == "#{host}_#{port}"
        session[:released] = nil
        session[:denominator] = nil
        res = roma.send_command('rbalse', nil, host, port) 
      else
        flash[:error_message] = "Please rbalse #{session[:released]} before that"
      end
    else
      res = roma.send_command('rbalse', nil, host, port) 
    end

    redirect_to :action => "index"
  end

  def update #[recover]
    gon.host = ConfigGui::HOST
    gon.port = ConfigGui::PORT

    roma = Roma.new
    res = roma.send_command('recover', nil) 

    @stats_hash = roma.get_stats
    @active_routing_list = roma.get_active_routing_list(@stats_hash)
    @inactive_routing_list = roma.get_all_routing_list - @active_routing_list
    @routing_info = roma.get_routing_info(@active_routing_list)
    gon.routing_info = @routing_info
    gon.denominator = @stats_hash["routing"]["short_vnodes"]
    session[:denominator] = gon.denominator

    render :action => "index"
  end

  def release #[release]
    host, port = params[:target_instance].split(/_/)
    gon.host = host
    gon.port = port

    roma = Roma.new
    res = roma.send_command('release', nil, host, port) 
    session[:released] = params[:target_instance]

    @stats_hash = roma.get_stats
    @active_routing_list = roma.get_active_routing_list(@stats_hash)
    @inactive_routing_list = roma.get_all_routing_list - @active_routing_list
    @routing_info = roma.get_routing_info(@active_routing_list)
    gon.routing_info = @routing_info
    session[:denominator] = @routing_info[params[:target_instance]]["primary_nodes"] + @routing_info[params[:target_instance]]["secondary_nodes"]
    gon.denominator = session[:denominator]

    render :action => "index"
  end
end
