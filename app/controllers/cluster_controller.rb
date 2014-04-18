class ClusterController < ApplicationController
  def index
    roma = Roma.new
    @stats_hash = roma.stats

    @routing_list = roma.get_instances_list
    @each_instance_status  = roma.get_instances_info(@routing_list, "status")
    @each_instance_size    = roma.get_instances_info(@routing_list, "size")
    @each_instance_version = roma.get_instances_info(@routing_list, "version")
    #render :text => @each_instance_status
  end

  def create
    @test = session[:instance]
  end

  def destroy
  end

  def update
  end
end
