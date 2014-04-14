class StatController < ApplicationController
  def index
    begin
      #roma = Roma.new.stats
      #@stats_hash = roma.stats_hash
      @stats_hash = Roma.new.stats
      #@stats_json = roma.stats_json
    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end

  def edit
    @key   = params[:key]
    @value = params[:value]
    @roma = Roma.new(@key => @value)
    #render :text => @value
  end

  def update
    @key   = params[:key]
    if @key == "continuous_limit"
      @value = "#{params[:continuous_start]}:#{params[:continuous_rate]}:#{params[:continuous_full]}"
    elsif @key == "sub_nid"
      @value = "#{params[:sub_nid_netmask]} #{params[:sub_nid_target]} #{params[:sub_nid_string]}"
    #elsif @key == "auto_recover_time"
    #  @value = "#{Roma.new.stats["routing"]["auto_recover"]} #{params[change_value]}"
    else
      @value = params[@key]
    end
    @roma = Roma.new(@key => @value)
    
    begin
      if @roma.check_param(@key, @value) && @roma.valid?
        @res = @roma.change_param(@key, @value)
      end
        @value = Roma.new.stats["routing"]["sub_nid"] if @key == "sub_nid"
        @value = Roma.new.stats["routing"]["auto_recover_time"] if @key == "auto_recover_time"
        render :action => "edit"
    rescue => @ex
      render :template => "errors/error_500", :status => 500
    end
  end
end
