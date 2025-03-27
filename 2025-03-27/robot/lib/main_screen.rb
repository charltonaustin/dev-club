# frozen_string_literal: true

require_relative './tasks/create_a_task'
require_relative './tasks/list_tasks'
require_relative './tasks/edit_task'
require_relative './tasks/view_task_history'
require_relative './tasks/default_task'
require_relative './tasks/revert_task'
require_relative './tasks/exit_task'
require_relative './tasks/wait_on_empty_task'

class MainScreen
  def initialize(tasks)
    @tasks = tasks
  end

  def do

    loop do
      system "clear"
      actions = [
        CreateATask,
        ListTasks,
        [WaitOnEmptyTask, EditTask],
        [WaitOnEmptyTask, ViewTaskHistory],
        [WaitOnEmptyTask, RevertTask],
        ExitTask,
      ].map.with_index do |action, i|
        if action.respond_to?(:new)
          action.new(@tasks, i + 1)
        else
          a = action[0].new(@tasks, i + 1)
          a.set_delegator(action[1])
        end
      end
      puts "\nWhat would you like to do?"
      actions.each do |action|
        puts "#{action.key}. #{action.description}"
      end

      action_map = actions.map.with_index { |x, i| [i + 1, x] }.to_h
      action_map.default = DefaultTask.new(@tasks, actions.size - 1)
      choice = gets.chomp.to_i
      @tasks = action_map[choice].do
    end
  end
end
