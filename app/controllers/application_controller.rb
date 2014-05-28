class ApplicationController < ActionController::Base
  before_filter :auth
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def auth
    name = 'roma'
    passwd = '8cb2237d0679ca88db6464eac60da96345513964' #12345
    authenticate_or_request_with_http_basic('Gladiator') do |n, p|
      n == name &&
        Digest::SHA1.hexdigest(p) == passwd
    end
  end

end
