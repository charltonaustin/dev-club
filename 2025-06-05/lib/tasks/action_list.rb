# frozen_string_literal: true
# typed: strict

class ActionList
  extend T::Sig

  sig { params(tasks: T::Array[TaskInterface]).void }
  def initialize(tasks)
    @tasks = tasks
  end

  sig { returns(T::Array[Action]) }
  def get_actions
    actions = T.let([CreateATask, ListTasksImproved, SaveTasks, LoadTasks].map.with_index do |action, i|
      action.new(@tasks, i + 1)
    end, T::Array[Action])

    other = T.let([EditTask, ViewTaskHistory, RevertTask, CompleteTask].map.with_index do |action, i|
      a = WaitOnEmptyTask.new(@tasks, actions.length + i + 1)
      a.set_delegator(action.new(@tasks, actions.length + i + 1))
    end, T::Array[Action])
    (actions + other) << Exit.new(@tasks, actions.length + other.length + 1) 
  end
end
