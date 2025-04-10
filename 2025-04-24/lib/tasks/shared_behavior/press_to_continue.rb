# frozen_string_literal: true

class PressToContinue
  def do
    puts 'Press enter to continue'
    $stdin.getc
  end
end
