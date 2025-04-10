# frozen_string_literal: true

class EditTask
  attr_accessor :key, :description

  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = 'Edit a task'
  end

  def do
    puts 'Enter the number of the task you want to edit:'
    input = GetAndDefault.new.get_and_default
    task_number = input.chomp.to_i
    puts 'Enter the new description for the task:'
    input = $stdin.gets
    input = '' if input.nil?
    new_description = input.chomp
    edit_task(task_number, new_description)
    @tasks
  end

  def edit_task(task_index, new_description)
    if task_index >= 1 && task_index <= @tasks.length
      task = @tasks[task_index - 1]
      task.history << new_description # Add the current description to history
      task.description = new_description
      puts "Task #{task_index} updated to: #{new_description}"
    else
      puts 'Invalid task number.'
    end
  end
end
