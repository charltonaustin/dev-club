# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require_relative './task_interface'

class TaskImproved
  extend T::Sig
  include TaskInterface
  
  sig { override.params(description: String).void}
  def description=(description)
    @description = description
  end

  sig { override.params(completed: T::Boolean).void}
  def completed=(completed)
    @completed = completed
  end

  sig { override.params(history: T::Array[String]).void }
  def history=(history)
    @history = history
  end

  sig { override.returns(String) }
  def description
    @description
  end

  sig { override.returns(T::Boolean) }
  def completed
    @completed
  end

  sig { override.returns(T::Array[String]) }
  def history
    @history
  end

  sig { params(description: String, completed: T::Boolean, history: T::Array[String]).void }
  def initialize(description, completed, history)
    @description = description
    @completed = completed
    @history = history
  end
  
  sig { params(index: Integer).void }
  def print(index)
    status = @completed ? '[x]' : '[ ]'
    puts "#{index + 1}. #{status} #{@description}"
  end
  
  sig { override.void }
  def complete
    @completed = true
  end
end
