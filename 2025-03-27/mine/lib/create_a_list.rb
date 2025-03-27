require_relative './todo_list'
class CreateAList
  def initialize(lists)
    @lists = lists
  end

  def do
    puts "Please input the list name:\n\n"
    list_name = gets.chomp
    @lists.append(TodoList.new(list_name))
  end
end