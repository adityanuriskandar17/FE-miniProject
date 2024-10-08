class InsuranceProductService
  include HTTParty
  base_uri 'http://localhost:3000/api/v1'

  def self.get_insurance_products(jwt)
    get('/insurance_products', headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end

  def self.get_insurance_product(jwt, id)
    get("/insurance_products/#{id}", headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end

  def self.create_insurance_product(jwt, insurance_product_params)
    post('/insurance_products', 
         body: insurance_product_params.to_json, 
         headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end

  def self.update_insurance_product(jwt, id, insurance_product_params)
    put("/insurance_products/#{id}",
        body: insurance_product_params.to_json,
        headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end

  def self.delete_insurance_product(jwt, id)
    delete("/insurance_products/#{id}", headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end
end
