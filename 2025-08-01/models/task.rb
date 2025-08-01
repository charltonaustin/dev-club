require "sqlite3"
module Models
  class Task
    @@db = SQLite3::Database.new "db/prod.db"

    def self.all
      values = []
      # simulate a really expensive database call
      sleep(2)
      @@db.execute("SELECT * FROM task") do |row|
        values.append(self.new(row[0], row[1], row[2] == 1))
      end
      values
    end

    def initialize(id = nil, name = nil, done = false)
      @id = id
      @done = done
      @name = name
    end

    def save
      if @id.nil?
        return insert
      end
      @id
    end

    def to_s
      "ID: #{@id} - #{@name}, #{@done}"
    end

    def to_j
      { id: @id, name: @name, done: @done }
    end

    private

    def insert
      @@db.execute("insert into task (name, done) values (?, ?)", [@name, @done ? 1 : 0])
      @id = @@db.last_insert_row_id
      @id
    end
  end
end
