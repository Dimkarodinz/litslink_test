class Payment < ApplicationRecord
  belongs_to :service

  validates :service, uniqueness: { scope: :line_item_id }
  validates :line_item_id, uniqueness: true

  def self.with(line_item_id:, service_id:)
    payment = self.find_or_create_by(line_item_id: line_item_id, service_id: service_id)
    yield(payment) if block_given?
    payment.save
  end

  # def self.with(line_item_id:, service_id:)
  #   payment = self.find_or_create_by(line_item_id: line_item_id, service_id: service_id)

  #   actual_payment_thread = Thread.list.select { |t| t.status == 'run' && t[:payment_id] == payment.id }.first

  #   if actual_payment_thread
  #     actual_payment_thread.queue << payment.id

  #   else
  #     Thread.new do
  #       Thread.current[:payment_id] = payment.id

  #       q = Queue.new

  #       while q
  #         self.with_update_payment(q.pop, &block)
  #       end
  #     end
  #   end
  # end

  private

  # def self.with_update_payment(payment)
  #   yield(payment) if block_given?
  #   payment.save
  # end
end
