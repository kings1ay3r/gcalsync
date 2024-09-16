class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    redirect_to sign_in_path, alert: "You must be signed in to access this page." unless current_user
  end
  allow_browser versions: :modern
end
