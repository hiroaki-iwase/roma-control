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
    #render :text => @value
  end

  def update
    @key   = params[:key]
    if @key == "continuous_limit"
      @value = "#{params[:start]}:#{params[:rate]}:#{params[:full]}"
    elsif @key == "sub_nid"
      @value = "#{params[:netmask]} #{params[:target]} #{params[:string]}"
    else
      @value = params[:change_value]
    end
    #render :text => @value #debug
    
    @res = Roma.new.change_param(@key, @value)
    
    # zenbu taiou saseru
    @value = Roma.new.stats["routing"]["sub_nid"] if @key == "sub_nid"
 
    render :action => "edit"
  end

end
