class CustomerService
  include HTTParty
  base_uri 'http://localhost:3000/api/v1'

  def self.get_customers(jwt)
    get('/customers', headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end

  def self.get_customer(jwt, id)
    get("/customers/#{id}", headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end

  def self.create_customer(jwt, customer_params)  
    post('/customers', 
         body: customer_params.to_json, 
         headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end
  

  def self.update_customer(jwt, id, customer_params)
    put("/customers/#{id}",
        body: customer_params.to_json,
        headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end
  

  def self.delete_customer(jwt, id)
    delete("/customers/#{id}", headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end  
end
