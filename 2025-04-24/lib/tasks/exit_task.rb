class ExitTask
  attr_accessor :key, :description

  def initialize(tasks, key)
    @tasks = tasks
    @description = 'Exit'
    @key = key
  end

  def do
    puts 'Exiting todo app. Goodbye!'
    exit(0)
  end
end