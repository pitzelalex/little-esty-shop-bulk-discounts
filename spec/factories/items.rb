FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item_#{n}" }
    sequence(:description) { |n| "Description_#{n}" }
    sequence(:unit_price) { |n| 10000 + (n * 1000) }
    association :merchant
  end
end
