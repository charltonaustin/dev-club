class Task
  attr_accessor :number, :todo

  def initialize(todo, number)
    @todo = todo
    @number = number
  end
  
  def replace_task(new_task)
    if @number == new_task.number
      @todo = new_task.todo
      return true
    end
    return false
  end
  def to_s
    "#{@number}. #{@todo}"
  end
end