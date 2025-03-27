class CreateATask
  attr_accessor :key, :description

  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = "Create a task"
  end

  def do
    puts "Enter the task description:"
    description = gets.chomp
    add_task(description)
    @tasks
  end

  def add_task(description)
    @tasks << { description: description, completed: false, history: [description] }
    puts "Task added: #{description}"
  end
end