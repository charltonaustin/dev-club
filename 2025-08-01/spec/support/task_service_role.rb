RSpec.shared_examples "task_service_role" do |parameter|
  let(:service) { Services::Task.new }
  it "responds to #get_all_tasks" do
    expect(service).to respond_to(:get_all_tasks)
  end
  it "responds to #get_tasks" do
    expect(service).to respond_to(:get_tasks)
  end
  it "responds to #create_task" do
    expect(service).to respond_to(:create_task)
  end
  it "responds to #blah" do
    expect(service).to respond_to(:blah)
  end
end