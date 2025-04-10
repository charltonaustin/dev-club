# frozen_string_literal: true

class Action
  def key
    raise NotImplementedError
  end
  
  def description
    raise NotImplementedError
  end
end
