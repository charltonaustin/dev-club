require_relative './shared_behavior/task_index_getter'
require_relative './shared_behavior/history_viewer'
require_relative './shared_behavior/get_and_default'

class RevertTask
  attr_accessor :key, :description

  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = 'Revert to previous version'
  end

  def do
    task_number = TaskIndexGetter.new(@tasks).get_index
    HistoryViewer.new(@tasks).view_task_history(task_number)
    puts 'Enter the number of the previous version you want to revert to:'
    input = GetAndDefault.new.get_and_default
    history_number = input.chomp.to_i
    revert_task(task_number, history_number)
    @tasks
  end

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