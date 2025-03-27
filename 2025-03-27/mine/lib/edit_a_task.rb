class EditATask
  def initialize(list)
    @list = list
  end
  
  def do
    puts "Please tell me the task number"
    task_number = Integer(gets.chomp)
    puts "Please enter the new task"
    task = gets.chomp
    @list.replace_task(Task.new(task, task_number))
    puts "Could not find #{task_name}"
  end
end