class PrintTasks
  def initialize(tasks)
    @tasks = tasks
  end

  def do
    if @tasks.empty?
      puts 'No tasks yet!'
    else
      puts '--- Your Todo List ---'
      @tasks.each_with_index do |task, index|
        status = task.completed ? '[x]' : '[ ]'
        puts "#{index + 1}. #{status} #{task.description}"
      end
      puts '-----------------------'
    end
  end
end