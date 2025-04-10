class TaskIndexGetter
  def initialize(tasks)
    @tasks = tasks
  end

  def get_index
    puts 'Enter the number of the task whose history you want to view:'
    s = $stdin.gets
    if s.nil?
      s = '0'
    end
    s.chomp.to_i
  end
end