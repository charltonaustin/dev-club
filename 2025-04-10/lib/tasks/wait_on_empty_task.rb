# frozen_string_literal: true
# typed: strict

class WaitOnEmptyTask
  extend T::Sig
  include Action

  sig { override.returns(Integer) }
  def key
    @key
  end

  sig { params(tasks: T::Array[Task], key: Integer).void }
  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @delegator = T.let(DefaultTask.new(tasks, key), Action)
  end

  sig { params(delegator: Action).returns(WaitOnEmptyTask) }
  def set_delegator(delegator)
    @delegator = delegator
    self
  end

  sig { override.returns(String) }
  def description
    @delegator.description
  end

  sig { override.returns(T::Array[Task]) }
  def do
    PrintTasks.new(@tasks).do
    if @tasks.empty?
      PressToContinue.new.do
      return @tasks
    end
    @delegator.do
  end
end