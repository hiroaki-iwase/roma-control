class StatController < ApplicationController
  def index
    begin
      roma = Roma.new
      #render :json => @stats_hash
      @stats_hash = roma.stats_hash
      @stats_json = roma.stats_json
    rescue => @ex
      render :template => "errors/error_500", :status => 500
      #render :action => "update"
      #render :nothing => true, :status => 404
    end
  end

  def update

  end
end
