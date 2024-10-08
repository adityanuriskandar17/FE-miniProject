# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :check_user_session

  private

  def check_user_session
    if session[:jwt].present?
      # Redirect to home if user is logged in
      redirect_to home_path if request.path == root_path
    end
  end
end
