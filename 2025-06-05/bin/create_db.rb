#! ruby
#typed: ignore
require "sqlite3"
require 'fileutils'

FileUtils.mkdir_p 'db'
# Open a database
db = SQLite3::Database.new "./db/tasks.db"
db.execute <<-SQL
  create table if not exists task (
    id integer primary key,
    description TEXT not null,
    completed boolean not null
  );
SQL

db.execute <<-SQL
  create table if not exists history (
    description  Text not null,
    task_id integer,
    FOREIGN KEY(task_id) REFERENCES task(id)
  );
SQL