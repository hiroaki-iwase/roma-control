class ApplicationController < ActionController::Base
  before_filter :check_logined_filter
  helper_method :login_check?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
