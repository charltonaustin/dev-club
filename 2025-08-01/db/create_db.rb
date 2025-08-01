require "sqlite3"
db = SQLite3::Database.new "db/prod.db"

db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS task (
    id integer primary key,
    name TEXT,
    done boolean
  )
SQL