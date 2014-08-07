class LoginController < ApplicationController
  skip_before_filter :check_logined_filter, :check_mklhash
  before_filter :redirect_top?, :only => 'index'
  
  def auth
    usr, type = User.authenticate(params['username'], Digest::SHA1.hexdigest(params['password']))

    if usr && type
      session[:username] = usr[:username]
      session[:password] = Digest::SHA1.hexdigest(usr[:password])
      session[:user_type] = type
      if usr[:email]
        session[:email] = usr[:email]
      else
        session[:email] = ''
      end

      roma = Roma.new
      stats_hash = roma.get_stats
      session[:active_routing_list] = roma.change_roma_res_style(stats_hash["routing"]["nodes"])
      session[:mklhash] = roma.send_command("mklhash 0", nil)

      Rails.logger.error(session[:active_routing_list])
      Rails.logger.error(session[:mklhash])
 
      if params[:referer]
        redirect_to params[:referer]
      else
        redirect_to :controller => 'cluster', :action => 'index'
      end

    else
      flash[:referer] = params[:referer]
      flash[:error] = 'username or password is incorrect!!'
      redirect_to :action => 'index'
    end
  end

  def logout
    reset_session
    redirect_to '/login/index'
  end

  private
  def redirect_top?
    redirect_to :controller => 'cluster', :action => 'index' if login_check?
  end
end
