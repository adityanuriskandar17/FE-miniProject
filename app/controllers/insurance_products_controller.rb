class InsuranceProductsController < ApplicationController
  before_action :require_jwt_token

  def index
    response = InsuranceProductService.get_insurance_products(session[:jwt])

    if response.code == 200
      @insurance_products = response.parsed_response
    else
      flash[:error] = "Failed to load insurance products"
      @insurance_products = []
    end
  end

  def new
    @insurance_product = {} # Use a hash instead of a model
  end
  
  def create
    response = InsuranceProductService.create_insurance_product(session[:jwt], insurance_product_params)
  
    if response.code == 201
      flash[:success] = "Insurance product created successfully"
      redirect_to insurance_products_path
    else
      flash[:error] = "Failed to create insurance product"
      redirect_to insurance_products_path
    end
  end

  def show
    response = InsuranceProductService.get_insurance_product(session[:jwt], params[:id])

    if response.code == 200
      @insurance_product = response.parsed_response
    else
      flash[:error] = "Failed to load insurance product"
      redirect_to insurance_products_path
    end
  end

  def edit
    response = InsuranceProductService.get_insurance_product(session[:jwt], params[:id])
    
    if response.code == 200
      @insurance_product = response.parsed_response
      Rails.logger.debug("Insurance product data in edit action: #{@insurance_product.inspect}")
    else
      flash[:error] = "Failed to load insurance product"
      redirect_to insurance_products_path
    end
  end
  
  def update
    response = InsuranceProductService.update_insurance_product(session[:jwt], params[:id], insurance_product_params)
    
    if response.code == 200
      flash[:success] = "Insurance product updated successfully"
      redirect_to insurance_product_path(params[:id])
    else
      flash[:error] = "Failed to update insurance product"
      render :edit
    end
  end

  def destroy
    response = InsuranceProductService.delete_insurance_product(session[:jwt], params[:id])
  
    if response.code == 200
      flash[:success] = "Insurance product deleted successfully"
    else
      flash[:error] = "Failed to delete insurance product"
    end

    redirect_to insurance_products_path
  end
  
  private

  def require_jwt_token
    unless session[:jwt]
      redirect_to new_session_path, alert: "You need to log in first."
    end
  end

  def insurance_product_params
    if params[:insurance_product]
      params.require(:insurance_product).permit(:name)
    else
      params.permit(:name)
    end
  end
end
