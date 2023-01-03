FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "item #{n}" }
    sequence(:description) { |n| "description #{n}" }
    unit_price {|n| 10000 + (n * 1000)}
    association :merchant
  end
end
