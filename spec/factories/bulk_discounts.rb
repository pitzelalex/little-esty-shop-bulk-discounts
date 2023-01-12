FactoryBot.define do
  factory :bluk_discount do
    threshold { 10 }
    discount { 0.80 }
    association :merchant
  end
end
