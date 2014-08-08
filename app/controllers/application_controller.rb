require 'my_error'

class ApplicationController < ActionController::Base
  before_filter :check_logined_filter, :check_mklhash
  helper_method :login_check?
  protect_from_forgery with: :exception

  rescue_from Exception,                        with: :render_500
  #rescue_from ActiveRecord::RecordNotFound,     with: :render_404
  #rescue_from ActiveRecord::RecordNotFound,     with: :change_base
  #rescue_from Errno::ECONNREFUSED,     with: :change_base
  rescue_from ConPoolError,     with: :change_base
  #rescue_from SignalException,     with: :change_base
  rescue_from ActionController::RoutingError,   with: :render_404

  def change_base
    Rails.logger.error("ConPoolError happened")
    Rails.logger.error("#{__method__} called")
    Rails.logger.error("session[:active_routing_list] #{session[:active_routing_list]}")

    if session[:active_routing_list]
      if session[:active_routing_list].size == 1
        Rails.logger.error("All instace were down")
        $Base_Host = nil
        $Base_Port = nil
        render_500 Errno::ECONNREFUSED.new
        return
      else
        session[:active_routing_list].each{|instance|
          begin
            Roma.new.send_command('whoami', nil, instance.split(/[:_]/)[0], instance.split(/[:_]/)[1])

            $Base_Host = instance.split(/[:_]/)[0]
            $Base_Port = instance.split(/[:_]/)[1]
            Rails.logger.error("changed Base HOST & PORT")
            Rails.logger.error("Base_instance => #{$Base_Host}_#{$Base_Port}")
            redirect_to :action => "index"
            return
          rescue
            next
          end 
        }

        Rails.logger.error("All instace were down")
        render_500 Errno::ECONNREFUSED.new
      end
    else
      Rails.logger.error("session[:active_routing_list] do NOT exists! (ROMA didn't boot yet.)")
      render_500 Errno::ECONNREFUSED.new
    end
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_404(exception = nil)
    if exception
      logger.error "Rendering 404 with exception: #{exception.message}"
    end

    unexpected_url = "http://#{request.host}:#{request.port.to_s + request.fullpath}"
    render :template => "errors/error_404", :locals => {:unexpected_url => unexpected_url}, :status => 404, :layout => 'application'
  end

  def render_500(exception = nil)
    if exception
      logger.error "Rendering 500 with exception: #{exception.message}"
      #logger.error "Rendering 500 with exception: #{exception.backtrace}"
    end
    render :template => "errors/error_500", :locals => {:ex => exception}, :status => 500, :layout => 'application'
  end

  private
  def login_check?
    if session[:username] && session[:password] && User.authenticate(session[:username], session[:password])
      return true
    end
    false
  end

  def check_logined_filter
    flash[:referer] = request.fullpath

    if session[:username] && session[:password]
      begin
        raise if !User.authenticate(session[:username], session[:password])
      rescue
        reset_session
        flash[:filter_msg] = "illegal user data!!"
        redirect_to :controller => 'login', :action => 'index'
      end
    else
      flash[:filter_msg] = "please login!!"
        redirect_to :controller => 'login', :action => 'index'
    end
  end

  def check_mklhash
    roma = Roma.new
    current_mklhash = roma.send_command("mklhash 0", nil)
    unless current_mklhash == session[:mklhash]
      stats_hash = roma.get_stats
      session[:active_routing_list] = roma.change_roma_res_style(stats_hash["routing"]["nodes"])
      session[:mklhash] = current_mklhash
      Rails.logger.error('Remake routing information')
      Rails.logger.error("session[:active_routing_list] #{session[:active_routing_list]}")
      Rails.logger.error("ession[:mklhash] #{session[:mklhash]}")
      #$Base_Host = session[:active_routing_list][0].split(/[:_]/)[0]
      #$Base_Port = session[:active_routing_list][0].split(/[:_]/)[1]
    end
  end

end
