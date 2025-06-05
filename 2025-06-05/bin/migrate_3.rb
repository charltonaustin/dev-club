#! ruby
#typed: ignore
require "sqlite3"
require 'fileutils'

FileUtils.mkdir_p 'db'
# Open a database
db = SQLite3::Database.new "./db/tasks.db"
db.execute <<-SQL
  ALTER TABLE task ALTER COLUMN description DROP NOT NULL;
SQL
db.execute <<-SQL
  ALTER TABLE history ALTER COLUMN description DROP NOT NULL;
SQL
