class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  private

  def authenticate_user!
    redirect_to new_session_path unless session[:jwt].present?
  end
end