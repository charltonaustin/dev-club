class ImportantConsumer
  def create_user
    uri = URI('http://127.0.0.1:4567/v1/user')
    body = { family_name: 'Last', first_name: 'First' }
    headers = { 'Content-Type': 'application/json' }
    JSON.parse(Net::HTTP.post(uri, body.to_json, headers).body).transform_keys(&:to_sym)
  end

  def get_user
    uri = URI('http://127.0.0.1:4567/v1/user/1')
    JSON.parse(Net::HTTP.get(uri)).transform_keys(&:to_sym)
  end
end