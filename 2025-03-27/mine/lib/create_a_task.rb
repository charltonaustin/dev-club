class CreateATask 
  def initialize(list)
    @list = list
  end
  
  def do
    puts "Please tell me the task"
    task_body = gets.chomp
    @list.add(Task.new(task_body, @list.size + 1))
  end
end