class AsuransiService
  include HTTParty
  base_uri 'http://localhost:3000/api/v1'

  def self.get_asuransis(jwt)
    get('/asuransis', headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end

  def self.get_asuransi(jwt, id)
    get("/asuransis/#{id}", headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end

  def self.create_asuransi(jwt, asuransi_params)
    Rails.logger.debug "Sending asuransi params: #{asuransi_params.inspect}"
    response = post('/asuransis',
         body: asuransi_params.to_json,
         headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
    Rails.logger.debug "Received response: #{response.inspect}"
    response
  end

  def self.update_asuransi(jwt, id, asuransi_params)
    put("/asuransis/#{id}",
        body: asuransi_params.to_json,
        headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end

  def self.delete_asuransi(jwt, id)
    delete("/asuransis/#{id}", headers: { 'Authorization' => "Bearer #{jwt}", 'Content-Type' => 'application/json' })
  end
end
