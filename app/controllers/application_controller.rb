class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Exception, :with => :render_500
  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end

    render :template => "errors/error_500", :status => 500, :layout => 'application'
  end

end
