# frozen_string_literal: true
# typed: strict

require_relative './shared_behavior/print_tasks'
require_relative './shared_behavior/press_to_continue'

class ListTasks
  extend T::Sig
  include Action

  sig { params(tasks: T::Array[Task], key: Integer).void }
  def initialize(tasks, key)
    @tasks = T.let(tasks, T::Array[Task])
    @description = T.let('List tasks', String)
    @key = T.let(key, Integer)
  end

  sig { override.returns(T::Array[Task]) }
  def do
    list_tasks
    @tasks
  end

  sig { returns(NilClass) }
  def list_tasks
    PrintTasks.new(@tasks).do
    PressToContinue.new.do
    nil
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
