require 'rails_helper'

describe Payment, type: :model do
  let(:service)  { create :service }


  describe 'unique indexes by' do
    let!(:example_payment) { create :payment, line_item_id: 1 }

    it '#line_item_id and #service_id' do
      payment = example_payment.dup
      expect{payment.save(validate: false)}.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it '#line_item_id' do
      payment = build :payment, line_item_id: 1
      expect{payment.save(validate: false)}.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'persists with both unique #service_id and #line_item_id' do
      payment = build :payment
      expect(payment.save(validate: false)).to be_truthy
    end

    it 'persists with unique #line_item_id and not unique #service_id' do
      payment = build :payment, service: example_payment.service
      expect(payment.save(validate: false)).to be_truthy
    end
  end


  describe 'validates #line_item_id and #service_id' do
    let!(:example_payment) { create :payment, line_item_id: 1 }

    it 'are both not unique' do
      payment = example_payment.dup
      expect(payment.valid?).to be_falsey
    end

    it '#line_item_id not unique' do
      payment = build :payment, line_item_id: 1
      expect(payment.valid?).to be_falsey
    end
  end


  context '.with' do
    let(:payment) { create :payment }

    it 'creates instance if not present with same attributes' do
      expect(described_class.count).to eq 0
      described_class.with(:line_item_id => 1, service_id: service.id)

      new_payment = described_class.last
      expect(new_payment.line_item_id).to eq 1
      expect(new_payment.service_id).to eq service.id
    end

    it 'updates new instance' do
      described_class.with(line_item_id: 1, service_id: service.id) do |payment|
        payment.line_item_id = 100500
      end

      new_payment = described_class.last
      expect(new_payment.line_item_id).to eq 100500
    end

    it 'updates existing instance' do
      conditions = {line_item_id: payment.line_item_id, service_id: payment.service_id}
      described_class.with(conditions) do |payment|
        payment.line_item_id = 100500
      end

      payment.reload
      expect(described_class.count).not_to be > 1
      expect(payment.line_item_id).to eq 100500
    end


    describe 'safe in concurency', clean_as_group: true do
      before do
        cond_args  = {line_item_id: payment.line_item_id, service_id: payment.service_id}
        cond_block = Proc.new { |payment| payment.line_item_id = 100500 }

        make_concurrent_calls(Payment, :with, cond_args, &cond_block)
      end

      it { expect(Payment.count).to eq 1 }
    end
  end
end