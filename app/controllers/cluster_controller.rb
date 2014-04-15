class ClusterController < ApplicationController
  def index
    Instance.new(active: true, name: "dev-actroma301zd_99999", ip: "127.0.0.1", del_flg: false)
    #@instances = Instance.attribute_names
    @instances = Instance.all
    #render :text => @instances
  end

  def create
  end

  def destroy
  end

  def update
  end
end
