class GetTasks
  def self.call
    tasks = Task.all
    tasks.map do |task|
      task.to_item
    end
  end
end