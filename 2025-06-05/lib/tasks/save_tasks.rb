# frozen_string_literal: true
# typed: strict

require "sqlite3"

class SaveTasks
  extend T::Sig
  include Action
  sig { params(tasks: T::Array[TaskInterface], key: Integer).void }

  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = T.let("Save tasks", String)
    @db = T.let(SQLite3::Database.new("./db/tasks.db"), SQLite3::Database)
  end

  sig { override.returns(T::Array[TaskInterface]) }
  def do
    puts "Saving tasks:"

    @tasks.each do |task|
      new_id = @db.execute "select max(id) + 1 from task"
      # noinspection RubyNilAnalysis
      @db.execute "insert into task (id, task_text, completed) values (?, ?, ?)", [new_id, task.description, task.completed.to_s]
      task.history.each do |h|
        # noinspection RubyNilAnalysis
        @db.execute "insert into history (task_id, task_text) values (?, ?)", [new_id, h]
      end
    end
    PressToContinue.new.do
    @tasks
  end

  sig { override.returns(String) }
  attr_reader :description
  sig { override.returns(Integer) }
  attr_reader :key
end
