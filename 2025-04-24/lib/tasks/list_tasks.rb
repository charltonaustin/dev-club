require_relative './shared_behavior/print_tasks'
require_relative './shared_behavior/press_to_continue'

class ListTasks
  attr_accessor :key, :description

  def initialize(tasks, key)
    @tasks = tasks
    @description = 'List tasks'
    @key = key
  end

  def do
    list_tasks
    @tasks
  end

  def list_tasks
    PrintTasks.new(@tasks).do
    PressToContinue.new.do
    nil
  end
end