class LoginController < ApplicationController
  skip_before_filter :check_logined

  #def index
  #end

  def auth
    usr = User.authenticate(params[:username], params[:password])  # have to modify

    @username_from_auth_controller = params[:username]
    @password_from_auth_controller = params[:password]

    if usr
      @debug_from_auth_controller = 'true'
      @referer_from_auth_controller = params[:referer]
      #session[:usr] = Digest::SHA1.hexdigest(usr.to_s)
      session[:usr] = Digest::SHA1.hexdigest(usr.to_s)
      session[:usrname] = params[:username]

      if params[:referer]
        #render 'index'
        redirect_to params[:referer]
      else
        redirect_to :controller => 'cluster', :action => 'index'
        #redirect_to '/cluster/index'
      end

    else
      @debug_from_auth_controller = 'false'
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
