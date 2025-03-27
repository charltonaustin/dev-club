require_relative './create_a_task'
require_relative './edit_a_task'


class EditAList

  def initialize(lists)
    @lists = lists
    @actions = [CreateATask, EditATask]
  end
  
  def do
    puts "Please tell me the name of the list to edit"
    list_name = gets.chomp
    @lists.each do |l|
      next unless l.name == list_name

      puts "1. Create a new task\n2. Edit a task"
      begin
        selection = Integer(gets.chomp)
        action = @actions[selection - 1]
        action.new(l).do
      rescue StandardError => e
        puts e
      end
    end
  end
end