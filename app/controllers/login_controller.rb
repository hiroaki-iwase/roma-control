class LoginController < ApplicationController
  skip_before_filter :check_logined

  def auth
    usr = User.authenticate(params[:username], params[:password])  # have to modify

    if usr
      #session[:usr] = Digest::SHA1.hexdigest(usr.to_s)
      session[:username] = params[:username]
      session[:password] = Digest::SHA1.hexdigest(params[:password])

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
