# frozen_string_literal: true

require_relative './tasks/create_a_task'
require_relative './tasks/list_tasks'
require_relative './tasks/edit_task'
require_relative './tasks/view_task_history'
require_relative './tasks/default_task'
require_relative './tasks/revert_task'
require_relative './tasks/exit_task'
require_relative './tasks/wait_on_empty_task'
require_relative './tasks/shared_behavior/get_and_default'
require_relative './tasks/action_list'

class MainScreen
  def initialize(tasks)
    @tasks = tasks
  end

  def do

    loop do
      system 'clear'
      actions = ActionList.new(@tasks).get_actions

      puts "\nWhat would you like to do?"
      actions.each do |action|
        puts "#{action.key}. #{action.description}"
      end

      action_map = actions.map.with_index { |x, i| [i + 1, x] }.to_h
      action_map.default = DefaultTask.new(@tasks, actions.size)
      input = GetAndDefault.new.get_and_default
      choice = input.chomp.to_i
      @tasks = action_map[choice].do
    end
    @tasks
  end
end
