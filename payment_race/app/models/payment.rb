class Payment < ApplicationRecord
  belongs_to :service

  validates :service, uniqueness: { scope: :line_item_id }
  validates :line_item_id, uniqueness: true

  # non-thread version
  # def self.with(line_item_id:, service_id:)
  #   payment = self.find_or_create_by(line_item_id: line_item_id, service_id: service_id)
  #   yield(payment) if block_given?
  #   payment.save
  # end

  # concurency .with with queue
  # 1. find or create payment
  # 2. look for thread with same payment_id
  #    2.1 if present, then add to thread queue
  #    2.2 if not present, then create thread with queue, add self to it
  #    2.3. loop unitl queue empty > update payment
  #    2.4. when queue nil, stop thread; close queue
  def self.with(line_item_id:, service_id:, &block)
    payment = self.find_or_create_by(line_item_id: line_item_id, service_id: service_id)

    actual_payment_thread = self.get_payment_thread(payment)

    if actual_payment_thread
      actual_payment_thread[:queue] << payment.id
    else
      queue = Queue.new
      queue << payment
      create_payment_thread(queue, payment, &block)
    end
  end

  def self.with_update_payment(payment)
    ActiveRecord::Base.connection_pool.with_connection do
      yield(payment) if block_given?
      payment.save
    end
  end

  private

  def self.get_payment_thread(payment)
    tr_arr = Thread.list.select do |t|
      t.status == 'run' && t[:payment] == payment
    end

    tr_arr.first
  end

  def self.create_payment_thread(queue, payment, &block)
    tr = Thread.new do
      Thread.current[:payment] = payment
      Thread.current[:queue]   = queue

      until queue.empty?
        member_payment = queue.pop rescue nil
        self.with_update_payment(payment, &block) if member_payment
      end

      queue.close
    end

    tr.join
  end
end
