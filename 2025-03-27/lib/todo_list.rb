class TodoList
  def initialize
    @tasks = []
  end

  # Add a new task
  def add(task)
    @tasks << task
  end

  # List all tasks
  def list
    @tasks
  end
end
