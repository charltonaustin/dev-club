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
    puts 'Enter the task name:'
    add_name($stdin.gets.chomp)
    puts 'Enter the task details (optional):'
    add_details($stdin.gets.chomp)
    @tasks
  end

  sig { params(name: String).returns(NilClass) }
  def add_name(name)
    @tasks << Task.new(name, name, false, [name])
    puts "Task added: #{name}"
  end

  sig { params(details: String).returns(NilClass) }
  def add_details(details)
    @tasks.last.details = details
    puts "Task details added: #{details}"
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
