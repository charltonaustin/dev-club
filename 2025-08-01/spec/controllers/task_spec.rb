require_relative '../../controllers/task'
ENV['APP_ENV'] = 'test'

describe 'Task test with Mocked Service', :controller do

  def app
    Sinatra::Application
  end

  describe "post" do

    it 'should respond with a 201' do
      task_data = { name: 'new task', done: false }
      post '/tasks', task_data.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_HOST' => '127.0.0.1' }
      expect(last_response.status).to eq 201
    end
  end
end
