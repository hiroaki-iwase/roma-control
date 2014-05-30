class LoginController < ApplicationController
  skip_before_filter :check_logined

  def auth
    usr = User.authenticate(params['username'], Digest::SHA1.hexdigest(params['password']))  # have to modify

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
      flash.now[:referer] = params[:referer]
      @error = 'username or password is incorrect'
      render 'index'
    end
  end

  def logout
    reset_session
    redirect_to '/login/index'
  end
end
