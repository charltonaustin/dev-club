class Task
  attr_accessor :description, :completed, :history

  def initialize(description, completed, history)
    @description = description
    @completed = completed
    @history = history
  end
end