# frozen_string_literal: true
# typed: strict

module Action
  extend T::Sig
  extend T::Helpers
  interface!

  sig { abstract.returns(Integer) }
  def key; end

  sig { abstract.returns(String) }
  def description; end

  sig { abstract.returns(T::Array[TaskInterface]) }
  def do; end
end
