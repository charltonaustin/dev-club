RSpec.shared_examples "task_model_role" do |parameter|
  it "responds to #save" do
    expect(task).to respond_to(:save)
  end
  it "responds to #to_j" do
    expect(task).to respond_to(:to_j)
  end
  it 'responds to .all' do
    expect(Models::Task).to respond_to(:all)
  end
end