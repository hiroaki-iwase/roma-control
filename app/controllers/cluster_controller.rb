class ClusterController < ApplicationController
  def index
    roma = Roma.new
    @stats_hash = roma.stats
    @routing_list = roma.get_instances_info

    @each_instance_status = {}
    @each_instance_size = {}
    @routing_list.each{|instance|
      if !@stats_hash["routing"]["nodes"].index(instance)
        status = "inactive"
        size = nil
      else
        each_stats = Roma.new(nil, instance.split("_")[0], instance.split("_")[1]).stats
 
        ### status[active|inactive|recover|join]
        if each_stats["stats"]["run_recover"].chomp == "true"
          status = "recover"
        elsif each_stats["stats"]["run_join"].chomp == "true"
          status = "join"
        else
          status = "active"
        end

        ### sum of tc file size of each instance 
        size = 0
        10.times{|index|
          size += each_stats["storages[roma]"]["storage[#{index}].fsiz"].to_i
        }
      end

      @each_instance_status.store(instance, status)
      @each_instance_size.store(instance, size)
    }
  end

  def create
    @test = session[:instance]
  end

  def destroy
  end

  def update
  end
end
