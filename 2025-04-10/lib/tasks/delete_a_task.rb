# frozen_string_literal: true
# typed: strict
require_relative './task'
require_relative './action'

class DeleteATask
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
    PrintTasks.new(@tasks).do
    puts 'Enter the number of the task you want to delete:'
    task_number = $stdin.gets.chomp.to_i
    delete_task(task_number)
    PrintTasks.new(@tasks).do
    @tasks
  end

  sig { params(task_number: Integer).returns(NilClass) }
  def delete_task(task_number)
    if task_number >= 1 && task_number <= @tasks.length
      @tasks.delete_at(task_number - 1)
      puts "Delete task #{task_number}"
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
