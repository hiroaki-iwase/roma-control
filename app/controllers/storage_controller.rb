class StorageController < ApplicationController
  def index
    begin
      @last_snapshot_data ||= nil

    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
 
  end

end
