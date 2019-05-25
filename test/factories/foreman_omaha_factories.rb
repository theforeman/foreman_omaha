FactoryBot.define do
  factory :omaha_report, :class => 'ForemanOmaha::OmahaReport' do
    host
    sequence(:reported_at) { |n| n.minutes.ago }
    status { 1 }
    omaha_version { '1068.9.0' }
    type { 'ForemanOmaha::OmahaReport' }
  end

  factory :omaha_facet, :class => 'ForemanOmaha::OmahaFacet' do
    sequence(:last_report) { |n| n.minutes.ago }
    version { '1068.9.0' }
    oem { 'rackspace' }
    sequence(:machineid) { SecureRandom.hex }
    status { 1 }
    host
    omaha_group
  end

  factory :omaha_group, :class => 'ForemanOmaha::OmahaGroup' do
    sequence(:name) { |n| "Omaha Group #{n}" }
    sequence(:uuid) { SecureRandom.uuid }
  end
end
