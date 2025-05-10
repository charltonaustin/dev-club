# frozen_string_literal: true
# typed: ignore

require_relative 'task'
require_relative 'shared_behavior/print_tasks'
require_relative 'shared_behavior/press_to_continue'

class Tasks
  extend Enumerable

  def initialize
    super
    @tasks = []
  end
  
  def list
    PrintTasks.new(@tasks).do
    @tasks.each { |task| task.print }
    PressToContinue.new.do    
  end
  
  def create_a_task(description, completed, history)
    @tasks << Task.new(description, completed, history)
    puts "Task added: #{description}"
  end
end
