require 'rails_helper'

describe Payment, type: :model do
  let(:line_item) { create :line_item}
  let(:service)  { create :service }

  describe '#line_item_id and #service_id' do
    it 'are present'
    it 'are not present'
    it 'checks at database level'
  end

  context '.with' do
    it 'creates instance if not present'
    it 'upates instance if present'
    it 'executes block'

    describe 'concurency' do
      context 'if #payment present' do
        it 'first thread updates instance, second wait then update'
      end

      context 'if #payment not present' do
        it 'first thread creates new, second wait then update'
      end
    end
  end
end