require_relative '../../controllers/task'
ENV['APP_ENV'] = 'test'

describe 'Task test with Mocked Service', :controller do
  let(:task_stub) { instance_double(Services::Task) }

  def app
    Sinatra::Application
  end

  describe "get /tasks/" do
    let(:task_stub) { instance_double(Services::Task) }

    context "with no status" do
      before do
        allow(Services::Task).to receive(:new).and_return(task_stub)
        allow(task_stub).to receive(:get_all_tasks).and_return({"fake" => "response"})
      end

      it "responds with a 200" do
        get '/tasks/', {}, { 'HTTP_HOST' => '127.0.0.1' }
        expect(last_response.status).to eq 200
        expect(JSON.parse(last_response.body)).to eq({ "tasks" => { "fake" => "response" }})
      end
    end

    context "with a status" do
      before do
        allow(Services::Task).to receive(:new).and_return(task_stub)
        allow(task_stub).to receive(:get_tasks).and_return({"fake" => "response"})
      end

      it "responds with a 200" do
        get '/tasks/completed', {}, { 'HTTP_HOST' => '127.0.0.1' }
        expect(last_response.status).to eq 200
        expect(JSON.parse(last_response.body)).to eq({ "tasks" => { "fake" => "response" }})
      end
    end
  end

  describe "get /should_fail" do
    before do
      pending "this is expected to fail"
      allow(Services::Task).to receive(:new).and_return(task_stub)
      allow(task_stub).to receive(:blan)
    end

    it "fails" do
      get '/should_fail', {}, { 'HTTP_HOST' => '127.0.0.1' }
      expect(last_response.status).to eq(200)
    end
  end

  describe "post" do
    before do
      allow(Services::Task).to receive(:new).and_return(task_stub)
      allow(task_stub).to receive(:create_task).and_return(2)
    end

    it 'should respond with a 201' do
      task_data = { name: 'new task', done: false }
      post '/tasks', task_data.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_HOST' => '127.0.0.1' }
      expect(last_response.status).to eq 201
      expect(last_response.body).to eq("{\"message\":\"Resource created successfully\",\"id\":2}")
    end
  end
end
