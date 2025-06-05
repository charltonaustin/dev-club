# frozen_string_literal: true
# typed: strict

class Exit
  extend T::Sig
  include Action

  sig { params(tasks: T::Array[TaskInterface], key: Integer).void }
  def initialize(tasks, key)
    @tasks = tasks
    @description = T.let('Exit', String)
    @key = key
  end

  sig { override.returns(T::Array[TaskInterface]) }
  def do
    puts 'Exiting todo app. Goodbye!'
    exit(0)
  end
  sig { override.returns(String) }
  def description
    @description
  end
  sig { override.returns(Integer) }
  def key
    @key
  end
end
