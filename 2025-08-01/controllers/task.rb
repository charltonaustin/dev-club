require 'sinatra'
require 'sinatra/json'
require_relative '../services/task'

# The controller is a client of the service.
get '/tasks/:status?' do |status|
  # Here are the queries.
  if status.nil? or not %w[completed incomplete].include?(status)
    json({ tasks: Services::Task.new.get_all_tasks })
  else
    json({ tasks: Services::Task.new.get_tasks(status) })
  end
end

get '/should_fail' do
  json({ tasks: Services::Task.new.blah })
end

post '/tasks' do
  task = JSON.parse(request.body.read).transform_keys(&:to_sym)
  # Here is an action.
  new_resource_id = Services::Task.new.create_task(task)
  status 201
  json({ message: 'Resource created successfully', id: new_resource_id })
end

