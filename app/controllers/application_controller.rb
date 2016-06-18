class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  #before_action :current_user, :require_login

  helper_method :current_user

  rescue_from ActionController::RoutingError, ActionController::UnknownController, ActiveRecord::RecordNotFound, with: :render_404
  rescue_from Exception, with: :render_500 unless Rails.env.development?


  def current_user
    @current_usre = nil
    if session[:user_id].present?
      @current_user = User.find(session[:user_id])
      redirect_to logout_path(referer) unless @current_user
    end
    @current_user
  end

  def require_login
    redirect_to referer unless session[:user_id]
  end

  def require_admin
    redirect_to referer unless (@current_user && @current_user.admin?)
  end

  def render_404(exception = nil)
    logger.info "Rendering 404: #{exception.message}" if exception
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

  def render_500
    render file: "#{Rails.root}/public/500.html", status: 500, layout: false
  end

  def referer
    request.referer || root_path
  end

end
