# frozen_string_literal: true
# typed: strict

class PressToContinue
  extend T::Sig

  sig { returns(String) }
  def do
    puts 'Press enter to continue'
    $stdin.getc || ""
  end
end
