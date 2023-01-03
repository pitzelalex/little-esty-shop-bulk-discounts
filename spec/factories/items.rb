FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "item #{n}" }
    sequence(:description) { "Default Description" }
    sequence(:unit_price) { |n| 10000 + (n * 1000)}
    association :merchant
  end
end
