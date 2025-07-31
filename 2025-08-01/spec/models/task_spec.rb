require_relative '../../models/task'

RSpec.describe Models::Task, :models do
  describe "should conform to role" do
    include_examples "task_model_role"
    let(:task) { Models::Task.new }
  end

  let(:connection) { SQLite3::Database.new("db/test.db") }

  around(:each) do |example|
    connection.execute("DROP TABLE IF EXISTS task")
    connection.execute("CREATE TABLE IF NOT EXISTS task (id integer primary key, name text, done boolean)")
    db = Models::Task.class_variable_get(:@@db)
    Models::Task.class_variable_set(:@@db, connection)

    example.run
    Models::Task.class_variable_set(:@@db, db)
  end

end
