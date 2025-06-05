# frozen_string_literal: true
# typed: strict

require_relative './task'
require_relative './action'

class CreateATask
  extend T::Sig
  include Action


  sig { params(tasks: T::Array[TaskInterface], key: Integer).void }
  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = T.let('Create a task', String)
  end

  sig { override.returns(T::Array[TaskInterface]) }
  def do
    puts 'Enter the task description:'
    add_task($stdin.gets.chomp)
    @tasks
  end

  sig { params(description: String).returns(NilClass) }
  def add_task(description)
    @tasks << Task.new(description, false, [description])
    puts "Task added: #{description}"
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
