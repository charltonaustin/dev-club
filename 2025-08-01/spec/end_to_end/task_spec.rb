require_relative '../../controllers/task'
ENV['APP_ENV'] = 'test'

describe 'End to end Task', :e2e do
  let(:connection) { SQLite3::Database.new("db/test.db") }

  around(:each) do |example|
    connection.execute("DROP TABLE IF EXISTS task")
    connection.execute("CREATE TABLE IF NOT EXISTS task (id integer primary key, name text, done boolean)")
    db = Models::Task.class_variable_get(:@@db)
    Models::Task.class_variable_set(:@@db, connection)

    example.run
    Models::Task.class_variable_set(:@@db, db)
  end

  def app
    Sinatra::Application
  end

  it 'post' do
    task_data = { name: 'new task', done: false }
    post '/tasks', task_data.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_HOST' => '127.0.0.1' }
    expect(last_response.status).to eq 201

    task_data = { name: 'new task', done: true }
    post '/tasks', task_data.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_HOST' => '127.0.0.1' }
    expect(last_response.body).to eq("{\"message\":\"Resource created successfully\",\"id\":2}")
    expect(last_response.status).to eq 201
  end

  it 'get' do
    connection.execute("insert into task (name, done) values (?, ?)", ["Name", 1])
    connection.execute("insert into task (name, done) values (?, ?)", ["Name 1", 0])
    get '/tasks/', {}, { 'HTTP_HOST' => '127.0.0.1' }
    expect(JSON.parse(last_response.body)).to eq({ "tasks" => [{ "done" => true, "id" => 1, "name" => "Name" },
                                                               { "done" => false, "id" => 2, "name" => "Name 1" }] })
    expect(last_response.status).to eq 200

  end

  it 'gets completed tasks' do
    connection.execute("insert into task (name, done) values (?, ?)", ["Name", 1])
    connection.execute("insert into task (name, done) values (?, ?)", ["Name 1", 0])
    get '/tasks/completed', {}, { 'HTTP_HOST' => '127.0.0.1' }
    expect(JSON.parse(last_response.body)).to eq({ "tasks" => [{ "done" => true, "id" => 1, "name" => "Name" }] })
    expect(last_response.status).to eq 200
  end

  it 'gets incompleted tasks' do
    connection.execute("insert into task (name, done) values (?, ?)", ["Name", 1])
    connection.execute("insert into task (name, done) values (?, ?)", ["Name 1", 0])
    get '/tasks/incomplete', {}, { 'HTTP_HOST' => '127.0.0.1' }
    expect(JSON.parse(last_response.body)).to eq({ "tasks" => [{ "done" => false, "id" => 2, "name" => "Name 1" }] })
    expect(last_response.status).to eq 200
  end

  it 'should fail and does' do
    get '/should_fail', {}, { 'HTTP_HOST' => '127.0.0.1' }
    expect(last_response.status).to eq 200
  end
end
