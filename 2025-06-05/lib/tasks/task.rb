# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require_relative './task_interface'

class Task
  extend T::Sig
  include TaskInterface

  sig { override.params(name: String).void}
  def name=(name)
    @name = name
  end

  sig { override.params(completed: T::Boolean).void}
  def completed=(completed)
    @completed = completed
  end

  sig { override.params(history: T::Array[String]).void }
  def history=(history)
    @history = history
  end

  sig { params(details: String).void }
  def details=(details)
    @details = details
  end

  sig { returns(String) }
  def name
    @name
  end

  sig { override.returns(String) }
  def description
    @description
  end

  sig { override.params(description: String).void }
  def description=(description)
    @description = description
  end

  sig { override.returns(T::Boolean) }
  def completed
    @completed
  end

  sig { override.returns(T::Array[String]) }
  def history
    @history
  end

  sig { returns(String || nil) }
  def details
    @details
  end

  sig { params(name: String, description: String, completed: T::Boolean, history: T::Array[String], details: String).void }
  def initialize(name, description, completed, history, details=nil)
    @name = name
    @description = description
    @completed = completed
    @history = history
    @details = details
  end

  sig { override.void }
  def complete
  end
end