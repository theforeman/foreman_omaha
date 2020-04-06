# frozen_string_literal: true

FactoryBot.modify do
  factory :feature do
    trait :omaha do
      name { 'Omaha' }
    end
  end
end
