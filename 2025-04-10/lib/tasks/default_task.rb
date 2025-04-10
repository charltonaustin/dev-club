# frozen_string_literal: true
# typed: strict

class DefaultTask
  extend T::Sig
  include Action
  sig { returns(Integer) }
  attr_accessor :key

  sig { returns(String) }
  attr_accessor :description

  sig { params(tasks: T::Array[Task], key: Integer).void }
  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = T.let('Invalid choice. Please try again.', String)
  end

  sig { override.returns(T::Array[Task]) }
  def do
    puts 'Invalid choice. Please try again.'
    @tasks
  end
end
