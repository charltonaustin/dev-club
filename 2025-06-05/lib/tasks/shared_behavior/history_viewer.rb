# frozen_string_literal: true
# typed: strict

class HistoryViewer
  extend T::Sig
  sig { params(tasks: T::Array[TaskInterface]).void }
  def initialize(tasks)
    @tasks = tasks
  end

  sig { params(task_index: Integer).void }
  def view_task_history(task_index)
    if task_index >= 1 && task_index <= @tasks.length
      task = T.must(@tasks[task_index - 1])
      if task.history.length <= 1
        puts 'No previous versions for this task.'
      else
        puts "--- Task #{task_index} History ---"
        task.history.each_with_index do |version, index|
          puts "#{index + 1}. #{version}"
        end
        puts '--------------------------'
      end
    else
      puts 'Invalid task number.'
    end
  end
end
