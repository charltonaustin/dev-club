# frozen_string_literal: true

class GetAndDefault
  def get_and_default
    input = $stdin.gets
    input = '0' if input.nil?
    input
  end
end
