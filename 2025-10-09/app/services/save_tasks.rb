class SaveTasks
  def self.call(tasks_params)
    tasks_params.map do |params|
      task = TaskItem.new(name: params[:name] , completed: params[:completed])
      t = Task.from_item(task)
      t.to_item
    end
  end
end