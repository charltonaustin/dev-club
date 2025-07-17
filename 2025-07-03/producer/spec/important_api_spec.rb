# frozen_string_literal: true

ENV['APP_ENV'] = 'test'
require_relative '../app/important_api'

describe 'GET users' do
  def app
    Sinatra::Application
  end
  it 'returns user 1' do
    user_data = { given_name: 'Jane', family_name: 'Doe' }
    post '/v1/user', user_data.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_HOST' => '127.0.0.1' }
    expect(last_response.status).to eq 200
    get '/v1/user/1', {}, { 'HTTP_HOST' => '127.0.0.1' }
    expect(last_response.body).to eq('{"family_name":"Doe","given_name":"Jane"}')
    expect(last_response.status).to eq 200
  end
end
