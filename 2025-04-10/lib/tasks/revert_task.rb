# frozen_string_literal: true
# typed: strict

require_relative './shared_behavior/task_index_getter'
require_relative './shared_behavior/history_viewer'

class RevertTask
  extend T::Sig
  include Action

  sig { override.returns(String) }
  def description
    @description
  end

  sig { override.returns(Integer) }
  def key
    @key
  end

  sig { params(tasks: T.untyped, key: T.untyped).void }
  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = T.let('Revert to previous version', String)
  end

  sig { override.returns(T::Array[Task]) }
  def do
    task_number = TaskIndexGetter.new(@tasks).index
    HistoryViewer.new(@tasks).view_task_history(task_number)
    puts 'Enter the number of the previous version you want to revert to:'
    history_number = gets.chomp.to_i
    revert_task(task_number, history_number)
    @tasks
  end

  sig { params(task_index: T.untyped, history_index: T.untyped).returns(NilClass) }
  def revert_task(task_index, history_index)
    if task_index >= 1 && task_index <= @tasks.length
      task = @tasks[task_index - 1]
      if history_index >= 1 && history_index <= task.history.length
        reverted_description = task.history[history_index - 1]
        task.history << reverted_description
        task.description = reverted_description
        puts "Task #{task_index} reverted to version #{history_index}: #{reverted_description}"
      else
        puts 'Invalid history version number.'
      end
    else
      puts 'Invalid task number.'
    end
  end
end