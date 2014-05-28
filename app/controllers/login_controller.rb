class LoginController < ApplicationController
  skip_before_filter :check_logined

  #def index
  #end

  def auth
    usr = User.authenticate(params[:username], params[:password])  # have to modify
    if usr
      session[:usr] = usr.object_id
      redirect_to params[:referer]
    else
      flash.now[:referer] = params[:referer]
      @error = 'username or password is incorrect'
      render 'index'
    end
  end
end
