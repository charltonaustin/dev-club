def contract_test
  uri = URI('http://127.0.0.1:4567/v1/user')
  body = { family_name: 'Last', first_name: 'First' }
  headers = { 'Content-Type': 'application/json' }

  json_parse = JSON.parse(Net::HTTP.post(uri, body.to_json, headers).body).transform_keys(&:to_sym)
  expect(json_parse).to have_key(:success?)
  expect(json_parse).to have_key(:id)
  uri = URI('http://127.0.0.1:4567/v1/user/1')

  json_parse = JSON.parse(Net::HTTP.get(uri)).transform_keys(&:to_sym)
  expect(json_parse).to have_key(:first_name)
  expect(json_parse).to have_key(:family_name)
end