class ApiController < ApplicationController
  def get_parameter
    stats_hash = Roma.new.get_stats

    res = stats_hash[params[:category]][params[:column]]

    if !res
      render :json => stats_hash
    else
      render :text => res
    end
  end
end
