require 'rails_helper'

RSpec.describe "todos/edit", type: :view do
  let(:todo) {
    Todo.create!(
      name: "MyString",
      description: "MyText",
      status: false
    )
  }

  before(:each) do
    assign(:todo, todo)
  end

  it "renders the edit todo form" do
    render

    assert_select "form[action=?][method=?]", todo_path(todo), "post" do

      assert_select "input[name=?]", "todo[name]"

      assert_select "textarea[name=?]", "todo[description]"

      assert_select "input[name=?]", "todo[status]"
    end
  end
end
