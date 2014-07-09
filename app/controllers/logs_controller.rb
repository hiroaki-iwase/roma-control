class LogsController < ApplicationController
  def index
    roma = Roma.new
    @raw_logs = roma.get_logs(10)
  end

  def download
  end
end
