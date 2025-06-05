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
    @description = T.let('Save tasks', String)
    @db = T.let(SQLite3::Database.new("./db/tasks.db"), SQLite3::Database)
  end

  sig { override.returns(T::Array[TaskInterface]) }
  def do
    puts 'Saving tasks:'
    
    @tasks.each_with_index do |task, i|
      # noinspection RubyNilAnalysis
      @db.execute "insert into task values (?, ?, ?)", [i, task.description, task.completed.to_s]
      task.history.each do |h|
        # noinspection RubyNilAnalysis
        @db.execute "insert into history values (?, ?)", [i, h]
      end
    end
    PressToContinue.new.do
    @tasks
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
