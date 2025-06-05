# frozen_string_literal: true
# typed: strict

class ListTasksImproved
  extend T::Sig
  include Action

  sig { params(tasks: T::Array[TaskInterface], key: Integer).void }
  def initialize(tasks, key)
    @tasks = T.let(tasks, T::Array[TaskInterface])
    @description = T.let('List tasks', String)
    @key = T.let(key, Integer)
  end

  sig { override.returns(T::Array[TaskInterface]) }
  def do
    if @tasks.empty?
      puts 'No tasks yet!'
      PressToContinue.new.do
      return @tasks
    end
    puts '--- Your Todo List ---'  
    @tasks.each_with_index do |task, index|
      TaskImproved.new(task.description, task.completed, task.history).print(index)
    end
    puts '-----------------------'
    PressToContinue.new.do
    @tasks
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
