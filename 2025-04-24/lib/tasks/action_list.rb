# frozen_string_literal: true

class ActionList
  def initialize(tasks)
    @tasks = tasks
  end

  def get_actions
    actions = [
      CreateATask,
      ListTasks,
      ExitTask,
    ].map.with_index do |action, i|
      action.new(@tasks, i + 1)
    end

    other = [
      EditTask,
      ViewTaskHistory,
      RevertTask
    ].map.with_index do |action, i|
      a = WaitOnEmptyTask.new(@tasks, actions.length + i + 1)
      a.set_delegator(action)
    end
    actions + other
  end
end
