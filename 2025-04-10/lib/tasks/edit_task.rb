# frozen_string_literal: true
# typed: strict

class EditTask
  extend T::Sig
  include Action

  sig { params(tasks: T::Array[Task], key: Integer).void }
  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = T.let('Edit a task', String)
  end

  sig { override.returns(T::Array[Task]) }
  def do
    puts 'Enter the number of the task you want to edit:'
    task_number = $stdin.gets.chomp.to_i
    puts 'Enter the new description for the task:'
    new_description = $stdin.gets.chomp
    edit_task(task_number, new_description)
    @tasks
  end

  sig { params(task_index: Integer, new_description: String).returns(NilClass) }
  def edit_task(task_index, new_description)
    if task_index >= 1 && task_index <= @tasks.length
      task = @tasks[task_index - 1]
      T.must(task).edit_task_description(new_description)
      puts "Task #{task_index} updated to: #{T.must(task).current_description}"
    else
      puts 'Invalid task number.'
    end
  end
  sig { override.returns(String) }
  def description
    @description
  end
  sig { override.returns(Integer) }
  def key
    @key
  end
end