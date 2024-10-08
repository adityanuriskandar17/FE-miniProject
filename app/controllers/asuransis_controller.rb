class AsuransisController < ApplicationController
  before_action :require_jwt_token

  # GET /asuransis
  def index
    response = AsuransiService.get_asuransis(session[:jwt])
  
    if response.code == 200
      @asuransis = response.parsed_response

      # Fetch all customers at once
      customers_response = CustomerService.get_customers(session[:jwt])
      if customers_response.code == 200
        customers = customers_response.parsed_response
        customer_map = customers.each_with_object({}) { |customer, map| map[customer['_id']] = customer['name'] }
      else
        customer_map = {}
      end

      # Fetch all insurance products at once
      products_response = InsuranceProductService.get_insurance_products(session[:jwt])
      if products_response.code == 200
        products = products_response.parsed_response
        product_map = products.each_with_object({}) { |product, map| map[product['id']] = product['name'] }
      else
        product_map = {}
      end

      # Set customer_name and insurance_product_name for each asuransi
      @asuransis.each do |asuransi|
        asuransi['customer_name'] = customer_map[asuransi['customer_id']] || 'Unknown Customer'
        asuransi['insurance_product_name'] = product_map[asuransi['insurance_product_id']] || 'Unknown Product'
      end
    else
      flash[:error] = "Failed to load Asuransis"
      @asuransis = []
    end
  end
  

  # GET /asuransis/new
  def new
    @asuransi = {}
    fetch_customers_and_products
  end

  # POST /asuransis
  def create
    response = AsuransiService.create_asuransi(session[:jwt], asuransi_params)

    if response.code == 201
      flash[:success] = "Asuransi created successfully"
      redirect_to asuransis_path
    else
      flash[:error] = "Only 1 insurance can be active"
      redirect_to new_asuransi_path
    end
  end

  # GET /asuransis/:id
  def show
    response = AsuransiService.get_asuransi(session[:jwt], params[:id])

    if response.code == 200
      @asuransi = response.parsed_response
    else
      flash[:error] = "Failed to load Asuransi"
      redirect_to asuransis_path
    end
  end

  # GET /asuransis/:id/edit
  def edit
    response = AsuransiService.get_asuransi(session[:jwt], params[:id])
  
    if response.code == 200
      @asuransi = response.parsed_response
      fetch_customers_and_products
    else
      flash[:error] = "Failed to load Asuransi"
      redirect_to asuransis_path
    end
  end

  # PATCH/PUT /asuransis/:id
  def update
    response = AsuransiService.update_asuransi(session[:jwt], params[:id], asuransi_params)

    if response.code == 200
      flash[:success] = "Asuransi updated successfully"
      redirect_to asuransi_path(params[:id])
    else
      flash[:error] = "Failed to update Asuransi"
      render :edit
    end
  end

  # DELETE /asuransis/:id
  def destroy
    response = AsuransiService.delete_asuransi(session[:jwt], params[:id])

    if response.code == 200
      flash[:success] = "Asuransi deleted successfully"
    else
      flash[:error] = "Failed to delete Asuransi"
    end
    redirect_to asuransis_path
  end

  private

  def require_jwt_token
    unless session[:jwt]
      redirect_to new_session_path, alert: "You need to log in first."
    end
  end

  def asuransi_params
    if params[:asuransi]
      params.require(:asuransi).permit(:status, :active_date, :expire_date, :customer_id, :insurance_product_id)
    else
      params.permit(:status, :active_date, :expire_date, :customer_id, :insurance_product_id)
    end
  end

  def fetch_customers_and_products
    # Fetch customers
    customers_response = CustomerService.get_customers(session[:jwt])
    @customers = customers_response.code == 200 ? customers_response.parsed_response : []
  
    # Fetch insurance products
    insurance_products_response = InsuranceProductService.get_insurance_products(session[:jwt])
    @insurance_products = insurance_products_response.code == 200 ? insurance_products_response.parsed_response : []
  end
end
