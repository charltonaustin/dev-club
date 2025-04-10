# frozen_string_literal: true
# typed: strict

class TaskIndexGetter
  extend T::Sig

  sig { params(tasks: T::Array[Task]).void }
  def initialize(tasks)
    @tasks = tasks
  end

  sig { returns(Integer) }
  def index
    puts 'Enter the number of the task whose history you want to view:'
    $stdin.gets.chomp.to_i
  end
end
