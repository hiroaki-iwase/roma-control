class ApplicationController < ActionController::Base
  before_filter :check_logined

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def login_check?
    if session[:username] && session[:password] && User.authenticate(session[:username], session[:password])
      return true
    end
    false
  end

  private
  def check_logined
    flash[:referer] = request.fullpath

    if session[:username] && session[:password]
      begin
        raise if !User.authenticate(session[:username], session[:password])
        @authorization = 'root'
        #@authorization = 'normal' #toDO
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
