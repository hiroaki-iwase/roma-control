class StatController < ApplicationController
  def index
    begin
      roma = Roma.new
      @stats_hash = roma.stats_hash
      @stats_json = roma.stats_json
    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  def edit
    @key = params[:key]
  end

  def update
  end

end
