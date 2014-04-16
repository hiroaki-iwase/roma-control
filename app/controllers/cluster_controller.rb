class ClusterController < ApplicationController
  def index
    @test = Roma.new.get_instances_info
    #@stats_hash = Roma.new.stats
    #routing_path = @stats_hash["config"]["RTTABLE_PATH"]
    #ip = @stats_hash["stats"]["address"]
    #s = File.read("#{routing_path}/*")
  end

  def create
    @test = session[:instance]
  end

  def destroy
  end

  def update
  end
end
