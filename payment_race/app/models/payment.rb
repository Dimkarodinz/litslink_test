class Payment < ApplicationRecord
  belongs_to :service

  validates :service, uniqueness: { scope: :line_item_id }
  validates :line_item_id, uniqueness: true

  def self.with(line_item_id:, service_id:)
    payment = self.find_or_create_by(line_item_id: line_item_id, service_id: service_id)
    yield(payment) if block_given?
    payment.save
  end

  # concurency .with with queue
  # def self.with(line_item_id:, service_id:, &block)
  #   # byebug
  #   payment = self.find_or_create_by(line_item_id: line_item_id, service_id: service_id)
  #   # p payment.errors.full_messages
  #   actual_payment_thread = Thread.list.select { |t| t.status == 'run' && t[:payment_id] == payment.id }.first

  #   # payment.id == nil?
  #   if actual_payment_thread
  #     # byebug
  #     actual_payment_thread[:queue] << payment.id

  #   else
  #     queue = Queue.new
  #     queue << payment.id
  #     # byebug
  #     Thread.new do


  #       Thread.current[:payment_id] = payment.id
  #       Thread.current[:queue]      = queue

  #       # self.with_update_payment(payment_id)

  #       # queue << payment_id

  #       until queue.empty?
  #         payment_id = queue.pop rescue nil

  #         if payment_id
  #           self.with_update_payment(payment_id)
  #         end
  #         # payment = Payment.find_by_id(payment)
  #         # yield(payment) if block_given?
  #         # payment.save
  #       end

  #       queue.close
  #     end
  #   end
  # end

  # # private

  # def self.with_update_payment(payment_id)
  #   byebug
  #   payment = self.find(payment_id)
  #   payment.line_item_id = 3014
  #   # yield(payment) if block_given?
  #   # yield(payment) if block_given?
  #   # block.call(payment) if block_given?
  #   payment.save

  #   p payment.errors.full_messages
  # end
end
