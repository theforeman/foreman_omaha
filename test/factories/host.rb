FactoryBot.modify do
  factory :host do
    trait :with_omaha_facet do
      association :omaha_facet, :factory => :omaha_facet, :strategy => :build
    end
  end
end
