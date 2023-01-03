FactoryBot.define do
  factory :transaction do
    association :invoice
    credit_card_number { 4000000000000000 + rand.to_s[2..16].to_i }
    credit_card_expiration_date { '' }
    result { 0 }

    trait :successful do
      result { 1 }
    end

    factory :successful_transaction, traits: [:successful]
  end
end
