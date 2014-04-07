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
    @roma_stats = Roma_stats.new(@key => @value)
    #render :text => @value
  end

  def update
    @key   = params[:key]
    if @key == "continuous_limit"
      @value = "#{params[:start]}:#{params[:rate]}:#{params[:full]}"
    elsif @key == "sub_nid"
      @value = "#{params[:netmask]} #{params[:target]} #{params[:string]}"
    #elsif @key == "auto_recover_time"
    #  @value = "#{Roma.new.stats["routing"]["auto_recover"]} #{params[change_value]}"
    else
      @value = params[@key]
      @roma_stats = Roma_stats.new(@key => @value)
    end
    logger.debug(@roma_stats.hilatency_warn_time)
    if @roma_stats.valid?
      @res = Roma.new.change_param(@key, @value)
    end
    #render :text => @res #debug
     
    @value = Roma.new.stats["routing"]["sub_nid"] if @key == "sub_nid"
    @value = Roma.new.stats["routing"]["auto_recover_time"] if @key == "auto_recover_time"
 
    render :action => "edit"
  end
  
  private
  def setParam(params)
    case params()
    when prams[""] == ""
      params.valid?
    end
  end
end
