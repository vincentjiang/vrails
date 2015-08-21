class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  include Pundit

  protect_from_forgery with: :exception

  helper_method :current_user_session, :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActionController::RoutingError, ActionController::UnknownController, ActiveRecord::RecordNotFound, with: :render_404

  private

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def user_not_authorized
      redirect_to (request.referrer || root_path), alert: "您没有此权限"
    end

    def render_404(exception = nil)
      logger.info "Rendering 404: #{exception.message}" if exception
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end

end
