class StatController < ApplicationController
  def index
    @stats_hash = Roma.new.get_stats
  end

  def edit
    @key   = params[:key]
    @value = params[:value]
    @roma = Roma.new(@key => @value)
    @stats_hash = @roma.get_stats
  end

  def update
    @key = params[:key]
    if @key == "continuous_limit"
      @value = "#{params[:continuous_start]}:#{params[:continuous_rate]}:#{params[:continuous_full]}"
    elsif @key == "sub_nid"
      @value = "#{params[:sub_nid_netmask]} #{params[:sub_nid_target]} #{params[:sub_nid_string]}"
    else
      @value = params[@key]
    end
    @roma = Roma.new(@key => @value)

    if @roma.check_param(@key, @value) && @roma.valid?
      @res = @roma.change_param(@key, @value)
    end

    @stats_hash = @roma.get_stats
    @value = @stats_hash["routing"][@key] if @key =~ /^sub_nid$/
    render :action => "edit"
  end
end
