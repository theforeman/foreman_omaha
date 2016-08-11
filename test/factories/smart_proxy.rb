FactoryGirl.modify do
  factory :smart_proxy do
    trait :omaha do
      features { |sp| [sp.association(:feature, :omaha)] }
    end
  end
end
