require_relative "../lib/todo_list"

RSpec.describe TodoList do
  let(:todo) { TodoList.new }

  describe "#add" do
    it "adds a task to the list" do
      todo.add("Buy groceries")
      expect(todo.list).to include("Buy groceries")
    end
  end

  describe "#list" do
    it "lists all tasks" do
      todo.add("Buy groceries")
      todo.add("Clean room")
      expect(todo.list).to eq(["Buy groceries", "Clean room"])
    end
  end
end
