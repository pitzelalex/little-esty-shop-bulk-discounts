FactoryBot.define do
  factory :invoice_item do
    quantity { rand(1..30) }
    item { association :item }
    unit_price { item.unit_price }
    status { 0 }
    association :invoice

    trait :packaged do
      status { 1 }
    end

    factory :packaged_ii, traits: [:packaged]
  end
end
