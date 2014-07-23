class StorageController < ApplicationController
  def index
    begin
      @last_snapshot_data ||= nil

    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
 
  end

  #def get
  #  roma = Roma.new
  #  begin
  #    @stats_hash = roma.get_stats
  #    @last_snapshot_data = nil #@stats_hash["storage"]["last_snapshot_date"]
  #    @value = roma.get_value(params[:key_name])

  #    #render :text => params[:key_name]
  #    render :template => "storage/data"
  #  rescue => @ex
  #    render :template => "errors/error_500", :status => 500
  #  end
  #end

  #def set
  #    render :template => "storage/data"
  #end 
 
end
