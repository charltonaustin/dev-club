class TodoList
  attr_accessor :name

  def initialize(name)
    @tasks = []
    @name = name
  end

  # Add a new task
  def add(task)
    @tasks << task
  end

  def replace_task(new_task)
    @tasks.each do |task|
      if task.replace_task(new_task)
        return true
      end
    end
    false
  end

  def size
    @tasks.size
  end

  # List all tasks
  def list
    puts "List #{@name}"
    puts "tasks:"
    @tasks.each { |t| puts t }
  end
end
