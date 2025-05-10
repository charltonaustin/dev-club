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
  def initialize(description, completed, history)
    @description = description
    @completed = completed
    @history = history
  end
end
