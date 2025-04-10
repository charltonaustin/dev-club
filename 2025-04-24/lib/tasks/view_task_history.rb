require_relative './shared_behavior/task_index_getter'
require_relative './shared_behavior/print_tasks'

class ViewTaskHistory
  attr_accessor :key, :description

  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = "View task history"
  end

  def do
    task_number = TaskIndexGetter.new(@tasks).get_index
    HistoryViewer.new(@tasks).view_task_history(task_number)
    PressToContinue.new.do
    @tasks
  end

end