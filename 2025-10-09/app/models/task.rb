class Task < ApplicationRecord
  def self.from_item(item)
    unless item.number
      return create!(name: item.name, completed: item.completed?)
    end
    return update_if_found(item)
  end

  def self.update_if_found(item)
    task = Task.find(item.number)
    if task
      task.update!(completed: item.completed?, name: item.name)
      return task
    end
  end

  def to_item
    TaskItem.new(name: name, completed: completed, number: id)
  end
end
