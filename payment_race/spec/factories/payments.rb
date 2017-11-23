FactoryBot.define do
  factory :payment do
    association :line_item
    association :service
  end
end
