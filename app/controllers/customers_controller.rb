class CustomersController < ApplicationController
  before_action :require_jwt_token

  def index
    response = CustomerService.get_customers(session[:jwt])

    if response.code == 200
      @customers = response.parsed_response
    else
      flash[:error] = "Failed to load customers"
      @customers = []
    end
  end

  def new
    @customer = {} # Use a hash instead of a model
  end
  
  def create
    response = CustomerService.create_customer(session[:jwt], customer_params)
  
    if response.code == 201
      flash[:success] = "Customer created successfully"
      redirect_to customers_path
    else
      flash[:error] = "Failed to create customer"
      redirect_to customers_path
    end
  end

  def show
    response = CustomerService.get_customer(session[:jwt], params[:id])

    if response.code == 200
      @customer = response.parsed_response
    else
      flash[:error] = "Failed to load customer"
      redirect_to customers_path
    end
  end

  def edit
    response = CustomerService.get_customer(session[:jwt], params[:id])
    
    if response.code == 200
      @customer = response.parsed_response
      Rails.logger.debug("Customer data in edit action: #{@customer.inspect}")
    else
      flash[:error] = "Failed to load customer"
      redirect_to customers_path
    end
  end
  
  def update
    response = CustomerService.update_customer(session[:jwt], params[:id], customer_params)
    
    if response.code == 200
      flash[:success] = "Customer updated successfully"
      redirect_to customer_path(params[:id])
    else
      flash[:error] = "Failed to update customer"
      render :edit
    end
  end
  

  def destroy
    response = CustomerService.delete_customer(session[:jwt], params[:id])
  
    if response.code == 204
      flash[:success] = "Customer deleted successfully"
    else
      flash[:error] = "Failed to delete customer"
    end

    redirect_to customers_path
  end
  
  private

  def require_jwt_token
    unless session[:jwt]
      redirect_to new_session_path, alert: "You need to log in first."
    end
  end

  def customer_params
    if params[:customer]
      params.require(:customer).permit(:name, :dob, :address, :phone)
    else
      params.permit(:name, :dob, :address, :phone)
    end
  end
  
  
end
