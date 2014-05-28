class ApplicationController < ActionController::Base
  before_filter :check_logined

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def check_logined
    if session[:usr]
      begin
        #raise if ConfigGui::ROOT_USER.include?(session[:usr])
        raise if authenticate(session[:usr], session[:pass])
        @usr = "oge"
      rescue
        reset_session
      end
    end

    unless @usr
      flash[:referer] = request.fullpath
      redirect_to :controller => 'login', :action => 'index'
    end
  end

end
