# frozen_string_literal: true
# typed: strict

class ClearList
  extend T::Sig
  include Action

  sig { params(tasks: T::Array[Task], key: Integer).void }
  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = T.let('Clear list of all tasks', String)
  end

  sig { override.returns(T::Array[Task]) }
  def do
    clear_task_list
    @tasks
  end

  sig { void }
  def clear_task_list
    if @tasks.length == 0
      puts "There are currently no tasks"
    else
      @tasks = []
      puts "All tasks removed"
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
