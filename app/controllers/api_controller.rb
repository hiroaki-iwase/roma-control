class ApiController < ApplicationController
  def get_parameter
    stats_hash = Roma.new.get_stats
    render :json => stats_hash
  end
end
