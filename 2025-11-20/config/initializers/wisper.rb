require "wisper"
require_relative "../../app/lib/wisper_listeners/create_todo"

Rails.application.reloader.to_prepare do
  Wisper.clear if Rails.env.development?

  Wisper.subscribe(WisperListener::CreateTodo.new)

end
