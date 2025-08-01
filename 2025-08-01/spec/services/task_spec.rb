require_relative '../../services/task'
require_relative '../../models/task'

RSpec.describe Services::Task, :services do
#  include_examples "task_service_role"
  describe 'create_task_mock conforms to task_model_role' do
    include_examples "task_model_role"
    let(:task) { create_task_mock }
  end

  describe "#get_all_tasks" do
    let(:task_stubs) do
      [
        instance_double(Models::Task, to_j: { id: 1 }),
        instance_double(Models::Task, to_j: { id: 2 })
      ]
    end

    before do
      allow(Models::Task).to receive(:all).and_return(task_stubs)
    end

    it "returns a list of hashes" do
      expect(subject.get_all_tasks).to match [{ id: 1 }, { id: 2 }]
    end
  end

  describe "#get_tasks" do
    let(:tasks) do
      [
        instance_double(Models::Task, to_j: {completed: true, id: 1}),
        instance_double(Models::Task, to_j: {completed: false, id: 2})
      ]
    end

    before do
      allow(Models::Task).to receive(:all).and_return(tasks)
    end

    describe "when status is completed" do
      it "returns completed tasks" do
        expect(subject.get_tasks("completed")).to contain_exactly({completed: true, id: 1})
      end
    end
    describe "when status is incomplete" do
      it "returns tasks that are not completed" do
        expect(subject.get_tasks("incomplete")).to contain_exactly({completed: false, id: 2})
      end
    end
  end

  describe "#create_task" do
    let(:task_stub) { instance_double(Models::Task) }
    before do
      allow(Models::Task).to receive(:new).and_return(task_stub)
    end

    it "creates a new task" do
      expect(task_stub).to receive(:save).once
      subject.create_task({ id: 1, name: "testing", completed: true })
    end
  end
end

def create_task_mock(is_done = false)
  j_data = { id: 1, name: "name", completed: is_done }
  task = instance_double(Models::Task)
  allow(task).to receive(:to_j).and_return(j_data)
  allow(task).to receive(:save).and_return(1)
  task
end
