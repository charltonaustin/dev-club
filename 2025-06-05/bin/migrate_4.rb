#! ruby
#typed: ignore
require "sqlite3"
require 'fileutils'

FileUtils.mkdir_p 'db'
# Open a database
db = SQLite3::Database.new "./db/tasks.db"
db.execute <<-SQL
  ALTER TABLE task DROP COLUMN description;
SQL
db.execute <<-SQL
  ALTER TABLE history DROP COLUMN description;
SQL
