class ApiController < ApplicationController
  def get_parameter
    stats_hash = Roma.new.get_stats

    c1 = params[:category]
    c2 = params[:column]

    res = stats_hash[c1][c2]

    if !res
      render :json => stats_hash
    else
      render :text => res
    end
  end
end
