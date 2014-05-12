class ClusterController < ApplicationController

  skip_before_filter :verify_authenticity_token ,:only=>[:update, :create]

  def index
    roma = Roma.new

    begin
      @stats_hash = roma.get_stats

      @active_routing_list = @stats_hash["routing"]["nodes"].chomp.delete("\"[]\s").split(",")
      @inactive_routing_list = roma.get_all_routing_list - @active_routing_list

      @routing_info= roma.get_routing_info(@active_routing_list)
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
    @test = session[:instance]
  end

  def destroy #[rbalse|balse]
    roma = Roma.new
    roma.get_stats
    a = roma.get_instances_list2
    render :text => a
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
end
