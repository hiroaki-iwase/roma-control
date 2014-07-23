class StorageController < ApplicationController
  def index
    begin
      @last_snapshot_data ||= nil

    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  def data
    res = Roma.new.set_value("hhh", "yyysdfwefw")
    render :text => res # debug
  end

end
