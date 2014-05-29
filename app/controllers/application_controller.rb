class ApplicationController < ActionController::Base
  before_filter :check_logined

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def check_logined

    if session[:usr]
      begin
        flash[:filter_msg] = "session[:usr] is exsicted [#{session[:usr]}]"
        raise if !User.authenticate_sha1(session[:usr])
      rescue
        reset_session
        flash[:filter_msg] = "illegal user data"
        flash[:referer] = request.fullpath
        redirect_to :controller => 'login', :action => 'index'
      end
    else
      flash[:filter_msg] = "please login========================"
        flash[:referer] = request.fullpath
        redirect_to :controller => 'login', :action => 'index'
    end
  end

end
