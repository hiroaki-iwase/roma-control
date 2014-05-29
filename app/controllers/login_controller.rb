class LoginController < ApplicationController
  skip_before_filter :check_logined

  def auth
    usr = User.authenticate(params[:username], params[:password])  # have to modify

    if usr
      #session[:usr] = Digest::SHA1.hexdigest(usr.to_s)
      session[:username] = usr[0]
      session[:password] = Digest::SHA1.hexdigest(usr[1])
      if usr[2]
        session[:email] = usr[2]
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
