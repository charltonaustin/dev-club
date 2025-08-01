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

  describe "#to_s" do
    subject { described_class.new(3, "testing", false) }

    it { expect(subject.to_s).to eq("ID: 3 - testing, false") }
  end

  describe "#to_j" do
    before do
      connection.execute("insert into task (name, done) values (?, ?)", ["Name", 1])
    end

    it "has completed true" do
      expect(described_class.all.first.to_j).to match(completed: true, id: 1, name: "Name")
    end
  end

  describe "#save" do
    context "when the id is nil" do
      context "when complete" do
        subject { described_class.new(nil, "other", true) }

        it "saves" do
          expect(subject.save).to eq(1)
          result = connection.execute("SELECT * FROM task where id = 1")
          expect(result).to contain_exactly([1, "other", 1])
        end
      end

      context "when not complete" do
        subject { described_class.new(nil, "other", false) }

        it "saves" do
          expect(subject.save).to eq(1)
          result = connection.execute("SELECT * FROM task where id = 1")
          expect(result).to contain_exactly([1, "other", 0])
        end
      end
    end

    context "when the id is not nil" do
      subject { described_class.new(1, "other", true) }

      it "saves" do
        expect(subject.save).to eq(1)
        result = connection.execute("SELECT count(*) FROM task")
        expect(result).to contain_exactly([0])
      end
    end
  end
end
