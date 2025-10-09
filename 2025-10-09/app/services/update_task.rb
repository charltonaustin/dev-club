class UpdateTask
  def self.call(id, should_complete, new_name)
    task = Task.find(id)
    task_item = task.to_item
    if new_name
      task_item.update_name(new_name)
    end 
    if should_complete
      task_item.complete!
    else
      task_item.reopen!
    end
    Task.from_item(task_item)
    task_item
  end
end