require_relative '../../services/task'
require_relative '../../models/task'



RSpec.describe Services::Task, :services do
  include_examples "task_service_role"
  describe 'create_task_mock conforms to task_model_role' do
    include_examples "task_model_role"
    let(:task) { create_task_mock }
  end
  describe "#get_all_tasks" do
  end

  describe "#get_tasks" do
    describe "when status is completed" do
    end
    describe "when status is incomplete" do
    end
  end

  describe "#create_task" do
  end
end

def create_task_mock(is_done = false)
  j_data = { id: 1, name: "name", done: is_done }
  task = instance_double(Models::Task)
  allow(task).to receive(:to_j).and_return(j_data)
  allow(task).to receive(:save).and_return(1)
  task
end