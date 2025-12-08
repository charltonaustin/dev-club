# frozen_string_literal: true
# typed: strict

class PrintTasks
  extend T::Sig

  sig { params(tasks: T::Array[TaskInterface]).void }
  def initialize(tasks)
    @tasks = tasks
  end

  sig { returns(NilClass) }
  def do
    if @tasks.empty?
      puts 'No tasks yet!'
    else
      puts '--- Your Todo List ---'
      @tasks.each_with_index do |task, index|
        status = task.completed ? '[x]' : '[ ]'
        puts "#{index + 1}. #{status} #{task.name}"
      end
      puts '-----------------------'
    end
  end
end
