#! ruby
#typed: ignore
require "sqlite3"
require 'fileutils'

FileUtils.mkdir_p 'db'
# Open a database
db = SQLite3::Database.new "./db/tasks.db"
db.execute <<-SQL
  UPDATE task SET task_text = description WHERE task_text IS NULL;
SQL
db.execute <<-SQL
  UPDATE history SET task_text = description WHERE task_text IS NULL;
SQL
