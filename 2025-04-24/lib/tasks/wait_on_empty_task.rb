class WaitOnEmptyTask

  attr_accessor :key

  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @delegator = DefaultTask.new(tasks, key)
  end

  def set_delegator(delegator)
    @delegator = delegator.new(@tasks, @key)
    self
  end

  def description
    @delegator.description
  end

  def do
    PrintTasks.new(@tasks).do
    if @tasks.empty?
      PressToContinue.new.do
      return @tasks
    end
    @delegator.do
  end
end