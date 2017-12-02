FactoryBot.modify do
  factory :host do
    trait :with_omaha_facet do
      association :omaha_facet, :factory => :omaha_facet, :strategy => :build

      transient do
        omaha_status 1
        omaha_version '1068.9.0'
        omaha_oem 'rackspace'
        omaha_group nil
      end

      after(:build) do |host, evaluator|
        host.omaha_facet.status = evaluator.omaha_status
        host.omaha_facet.version = evaluator.omaha_version
        host.omaha_facet.oem = evaluator.omaha_oem
        host.omaha_facet.omaha_group = evaluator.omaha_group if evaluator.omaha_group.present?
      end
    end
  end
end
