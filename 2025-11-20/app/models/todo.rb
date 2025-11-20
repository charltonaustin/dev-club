class Todo < ApplicationRecord
  validates :name, presence: true
  validates :status, inclusion: { in: [true, false] }

  include Wisper::Publisher

  after_create     :publish_creation_successful
  after_validation :publish_creation_failed, on: :create
  def publish_creation_successful
    broadcast(:todo_creation_successful, self)
  end

  def publish_creation_failed
    broadcast(:todo_creation_failed, self) if errors.any?
  end
end
