class LoginController < ApplicationController
  skip_before_filter :check_logined
  before_filter :redirect_top?, :only => 'index'
  
  def auth
    usr = User.authenticate(params['username'], Digest::SHA1.hexdigest(params['password']))

    if usr
      session[:username] = usr[:username]
      session[:password] = Digest::SHA1.hexdigest(usr[:password])
      if usr[:email]
        session[:email] = usr[:email]
      else
        session[:email] = ''
      end

      if params[:referer]
        redirect_to params[:referer]
      else
        redirect_to :controller => 'cluster', :action => 'index'
      end

    else
      flash[:referer] = params[:referer]
      flash[:error] = 'username or password is incorrect'
      redirect_to :action => 'index'
    end
  end

  def logout
    reset_session
    redirect_to '/login/index'
  end

  private
  def redirect_top?
    if session[:username] && session[:password] && User.authenticate(session[:username], session[:password])
      redirect_to :controller => 'cluster', :action => 'index'
    end
  end
end
