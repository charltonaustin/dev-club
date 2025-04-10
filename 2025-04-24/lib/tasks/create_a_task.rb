require_relative './task'
class CreateATask
  attr_accessor :key, :description

  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = "Create a task"
  end

  def do
    puts "Enter the task description:"
    input = $stdin.gets
    if input.nil?
      input = ''
    end
    description = input.chomp
    add_task(description)
    @tasks
  end

  def add_task(description)
    @tasks << Task.new(description, false, [description])
    puts "Task added: #{description}"
  end
end