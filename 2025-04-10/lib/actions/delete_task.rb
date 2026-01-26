# frozen_string_literal: true
# typed: strict

class DeleteTask
  extend T::Sig
  include Action

  sig { params(tasks: T::Array[Task], key: Integer).void }
  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = T.let('Delete a task', String)
  end

  sig { override.returns(T::Array[Task]) }
  def do
    puts 'Enter the number of the task you want to delete:'
    task_number = $stdin.gets.chomp.to_i
    complete_task(task_number)
    @tasks
  end

  sig { params(task_index: Integer).void }
  def complete_task(task_index)

    if task_index >= 1 && task_index <= @tasks.length
      @tasks.delete_at(task_index - 1)
      puts "Task #{task_index} deleted"
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
