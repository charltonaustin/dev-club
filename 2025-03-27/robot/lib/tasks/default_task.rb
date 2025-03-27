class DefaultTask
  attr_accessor :key, :description

  def initialize(tasks, key)
    @tasks = tasks
    @key = key
    @description = 'Invalid choice. Please try again.'
  end

  def do
    puts 'Invalid choice. Please try again.'
    @tasks
  end
end