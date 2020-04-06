# frozen_string_literal: true

FactoryBot.modify do
  factory :smart_proxy do
    trait :omaha do
      features { |sp| [sp.association(:feature, :omaha)] }
    end
  end
end
