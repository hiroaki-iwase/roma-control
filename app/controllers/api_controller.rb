class ApiController < ApplicationController
  def get_parameter
    stats_hash = Roma.new.get_stats

    category = params[:category]
    column = params[:column]

    target = stats_hash[category][column]

    if !target
      render :json => stats_hash
    else
      render :json => {
        category => {
          column => target
        }
      }
    end
  end
end
