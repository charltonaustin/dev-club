# frozen_string_literal: true
# typed: strict

require_relative './task'
require_relative './action'

class CompleteTask
  extend T::Sig
  include Action


  sig { params(tasks: T::Array[TaskInterface], key: Integer).void }
  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = T.let('Complete a task', String)
  end

  sig { override.returns(T::Array[TaskInterface]) }
  def do
    puts 'Enter task to complete:'
    complete_task($stdin.gets.chomp.to_i)
    @tasks
  end

  sig { params(task_location: Integer).returns(NilClass) }
  def complete_task(task_location)
    if task_location >= 1 && task_location <= @tasks.length
      task = @tasks[task_location - 1]
      T.must(task).completed = true
      puts "Task #{task_location} marked as completed."
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
