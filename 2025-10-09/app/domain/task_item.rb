class TaskItem
  attr_reader :name, :number

  def initialize(name:, completed: false, number: nil)
    @number = number
    @name = name
    @completed = completed
  end
  
  def update_name(new_name)
    if new_name == "completed task"
      return
    end
    @name = new_name
  end

  def complete!
    @completed = true
  end

  def reopen!
    @completed = false
  end
  
  def completed?
    @completed
  end
end