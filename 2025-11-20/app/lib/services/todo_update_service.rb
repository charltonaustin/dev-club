# frozen_string_literal: true

class TodoUpdateService
  def initialize(controller)
    @controller = controller
  end
  
  def todo_update_successful(todo)
    @controller.redirect_to todo, notice: "Todo was successfully updated.", status: :see_other
  end
  
  def todo_update_failed
    @controller.render :edit, status: :unprocessable_content
  end
end
