class ListAList
  def initialize(lists)
    @lists = lists
  end
  
  def do
    puts "Please tell me the list name\n\n"
    list_name = gets.chomp
    @lists.each do |l|
      if l.name == list_name
        l.list
        return
      end
    end
    puts "Could not find a list named #{list_name}"
  end
end