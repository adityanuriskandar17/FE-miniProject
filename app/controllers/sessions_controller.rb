# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  require 'httparty'

  def new
    # Render login form
  end

  def create
    response = HTTParty.post('http://localhost:3000/users/sign_in',
                             body: { user: { email: params[:email], password: params[:password] } }.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    if response.code == 200
      # Extract JWT token from the response header
      token = response.headers['Authorization'].split(' ').last

      # Store the JWT token in the session for later use
      session[:jwt] = token

      # Redirect to the customers page or any other page
      redirect_to customers_path
    else
      # Handle login failure
      flash[:error] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    # Clear session on logout
    session[:jwt] = nil

    # Clear all cookies
    cookies.each do |cookie_name, _|
      cookies.delete(cookie_name)
    end

    # Redirect to root path with a notice
    redirect_to root_path, notice: "Logged out successfully"
  end
end
