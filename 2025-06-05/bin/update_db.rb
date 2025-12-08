require "sqlite3"

db = SQLite3::Database.new "./db/tasks.db"
db.execute <<-SQL
  ALTER TABLE task ADD COLUMN name TEXT;
SQL
db.execute <<-SQL
   ALTER TABLE task ADD COLUMN details TEXT;
SQL