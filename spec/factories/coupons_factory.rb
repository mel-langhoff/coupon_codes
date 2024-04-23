FactoryBot.define do
  factory :coupon do
    name { Faker::Lorem.sentence(word_count:3)  }
    code { "BOGO50" }
    value_type { "50" }
    value_off { "percent" }
    active { true }
    association :merchant
    association :item
  end
end