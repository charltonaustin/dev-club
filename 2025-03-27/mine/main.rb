#! ruby
require_relative 'lib/todo_list'
require_relative 'lib/task'
require_relative 'lib/create_a_list'
require_relative 'lib/list_a_list'
require_relative 'lib/edit_a_list'
list_actions = [CreateAList, ListAList, EditAList]
todo_lists = []
while true do
  puts "Please select an option:\n\n1. Create a new list\n2. List a list\n3. Edit an existing list"
  begin
    selection = Integer(gets.chomp)
    action = list_actions[selection - 1]
    action.new(todo_lists).do
  rescue => e
    puts e.message
    puts "Could not parse selection. Please try again."
  end
end