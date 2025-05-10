# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'

class Task
  extend T::Sig

  sig { returns(String) }
  attr_accessor :description
  sig { returns(T::Boolean) }
  attr_accessor :completed
  sig { returns(T::Array[String]) }
  attr_accessor :history

  sig { params(description: String, completed: T::Boolean, history: T::Array[String]).void }
  def initialize(description, completed, history, deleted)
    @description = description
    @current_description = T.let("", String)
    @completed = completed
    @history = history
    @deleted = deleted
  end
  
  sig { returns(String) }
  def current_description
    @current_description
  end

  sig { params(new_description: String).void }
  def edit_task_description(new_description)
    @history << new_description
    @current_description = new_description
  end
  
  def print
    if @deleted
      return
    end
    completed ? '[x]' : '[ ]'
    puts "#{index + 1}. #{status} #{task.description}"
  end
end