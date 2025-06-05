# frozen_string_literal: true
# typed: strict

require "sqlite3"

class LoadTasks
  extend T::Sig
  include Action
  sig { params(tasks: T::Array[TaskInterface], key: Integer).void }

  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = T.let("Load tasks", String)
    @db = T.let(SQLite3::Database.new("./db/tasks.db"), SQLite3::Database)
  end

  sig { override.returns(T::Array[TaskInterface]) }
  def do
    puts "Loaded tasks"
    @db.execute "select id, task_text, completed from task;" do |row|
      history = []
      @db.execute "select task_id, task_text from history where task_id = ?", row[0] do |h_row|
        history << h_row[1]
      end
      completed = false
      if row[2] == 1
        completed = true
      end
      @tasks << Task.new(row[1], completed, history)
    end

    PressToContinue.new.do
    @tasks
  end

  sig { override.returns(String) }
  attr_reader :description
  sig { override.returns(Integer) }
  attr_reader :key
end
