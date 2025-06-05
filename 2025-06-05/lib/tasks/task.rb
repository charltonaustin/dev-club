# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require_relative './task_interface'

class Task
  extend T::Sig
  include TaskInterface

  sig { override.params(description: String).void}
  def description=(description)
    @description = description
  end

  def task_text=(task_text)
    @task_text = task_text
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
    @task_text
  end

  sig { override.returns(String) }
  def task_text
    @task_text
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
    @task_text = description
  end

  sig { override.void }
  def complete
  end
end
