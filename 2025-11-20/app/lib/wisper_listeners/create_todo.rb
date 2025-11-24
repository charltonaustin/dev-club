module WisperListener
  class CreateTodo
    def todo_creation_successful(todo)
      puts "todo_creation_successful_global"
      puts todo.to_json
    end
    def todo_creation_failed(todo)
      puts "todo_creation_failed"
      puts todo.errors.to_json
    end
  end
end