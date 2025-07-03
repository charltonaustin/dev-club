# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'

set :bind, '0.0.0.0'

users = []

post '/v1/user' do
  user = JSON.parse(request.body.read).transform_keys(&:to_sym)
  if user[:first_name] && user[:given_name].nil?
    user[:given_name] = user[:first_name]
  end
  users.append(user)
  json success?: true, id: users.length
end

get '/v1/user/:id' do |id|
  id = id.to_i
  json family_name: users[id - 1][:family_name], first_name: users[id - 1][:given_name], given_name: users[id - 1][:given_name]
end

delete '/v1/user/:id' do |id|
  id = id.to_i
  users.delete_at(id - 1)
  json success?: true, id: id
end
