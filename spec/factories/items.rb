FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item_#{n}" }
    sequence(:description) { |n| "Description_#{n}" }
    sequence(:unit_price) { |n| 10000 + (n * 1000) }
    status { 0 }
    association :merchant

    trait :enabled do
      status { 1 }
    end
  end
end
