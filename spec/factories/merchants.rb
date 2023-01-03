FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "merchant #{n}" }
  end
end
