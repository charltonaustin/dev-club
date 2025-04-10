# frozen_string_literal: true
# typed: strict

class ActionList
  extend T::Sig

  sig { params(tasks: T::Array[Task]).void }
  def initialize(tasks)
    @tasks = tasks
  end

  sig { returns(T::Array[Action]) }
  def get_actions
    actions = T.let([CreateATask, ListTasks].map.with_index do |action, i|
      action.new(@tasks, i + 1)
    end, T::Array[Action])

    other = T.let([EditTask, CompleteTask, DeleteTask, ViewTaskHistory, RevertTask, ClearList].map.with_index do |action, i|
      a = WaitOnEmptyTask.new(@tasks, actions.length + i + 1)
      a.set_delegator(action.new(@tasks, actions.length + i + 1))
    end, T::Array[Action])

    actions_list = actions + other
    actions_list << Exit.new(actions_list.length + 1)
  end
end
