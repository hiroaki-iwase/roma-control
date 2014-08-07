class ApplicationController < ActionController::Base
  before_filter :check_logined_filter
  helper_method :login_check?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Exception,                        with: :render_500
  rescue_from ActiveRecord::RecordNotFound,     with: :render_404
  rescue_from ActionController::RoutingError,   with: :render_404

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
      #logger.error "Rendering 500 with exception: #{exception.class}"
      #logger.error "Rendering 500 with exception: #{exception.message}"
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

end
