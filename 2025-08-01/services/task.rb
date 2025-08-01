require_relative '../models/task'
module Services
  # Service is a supplier for the controller and a client of the active record model.
  class Task
    def get_all_tasks
      # Here is an example of a query.
      Models::Task.all.map(&:to_j)
    end

    def get_tasks(status)
      # Here is an example of a query.
      all_tasks = Models::Task.all.map(&:to_j)
      if status == "completed"
        all_tasks.select { |task| task[:completed] }
      else
        all_tasks.select { |task| not task[:completed] }
      end
    end

    def create_task(task)
      t = Models::Task.new(task[:id], task[:name], task[:completed])
      # Here is an example of an action, command, or a side effect call so should be tested
      # It is also a query because it returns a value.
      t.save
    end
  end
end
