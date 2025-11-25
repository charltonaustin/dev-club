class Todo < ApplicationRecord
  validates :name, presence: true
  validates :status, inclusion: { in: [true, false] }

  include Wisper::Publisher

  after_create     :publish_creation_successful
  after_update     :publish_update_successful
  after_validation :publish_creation_failed, on: :create
  after_validation :publish_update_failed, on: :update
  def publish_creation_successful
    broadcast(:todo_creation_successful, self)
  end

  def publish_creation_failed
    broadcast(:todo_creation_failed, self) if errors.any?
  end
  
  def publish_update_successful
    broadcast(:todo_update_successful, self)
  end

  def publish_update_failed
    broadcast(:todo_update_failed, self) if errors.any?
  end
end
