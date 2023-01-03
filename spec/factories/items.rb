FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "item #{n}" }
    sequence(:description) { |n| "description #{n}" }
    unit_price { rand(100..10000)}
    association :merchant
  end
end
