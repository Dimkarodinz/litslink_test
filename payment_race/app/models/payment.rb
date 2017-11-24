class Payment < ApplicationRecord
  belongs_to :service

  validates :service, uniqueness: { scope: :line_item_id }
  validates :line_item_id, uniqueness: true

  def self.with(line_item_id:, service_id:, &block)
    payment = self.find_or_create_by(line_item_id: line_item_id, service_id: service_id)
    ThreadSafeUpdate.call(payment, &block)
  end
end
