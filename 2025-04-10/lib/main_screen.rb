# frozen_string_literal: true
# typed: strict

require_relative './tasks/create_a_task'
require_relative './tasks/list_tasks'
require_relative './tasks/edit_task'
require_relative './tasks/view_task_history'
require_relative './tasks/default_task'
require_relative './tasks/revert_task'
require_relative './tasks/exit_task'
require_relative './tasks/wait_on_empty_task'
require_relative './tasks/action_list'

class MainScreen
  extend T::Sig

  sig { params(tasks: T.nilable(T::Array[Task])).void }
  def initialize(tasks)
    @tasks = tasks
  end

  sig { void }
  def do
    loop do
      system 'clear'
      actions = ActionList.new(T.must(@tasks)).get_actions

      puts "\nWhat would you like to do?"
      actions.each do |action|
        puts "#{action.key}. #{action.description}"
      end

      choice = T.let($stdin.gets.chomp.to_i, Integer)
      wait_on_empty_task_new = WaitOnEmptyTask.new(T.must(@tasks), actions.size)
      wait_on_empty_task_new.set_delegator(DefaultTask.new(T.must(@tasks), actions.size))
      @tasks = actions[choice - 1]&.do || wait_on_empty_task_new.do
    end
  end
end
