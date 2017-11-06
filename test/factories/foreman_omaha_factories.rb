FactoryBot.define do
  factory :omaha_report, :class => 'ForemanOmaha::OmahaReport' do
    host
    sequence(:reported_at) { |n| n.minutes.ago }
    status 1
    omaha_version '1068.9.0'
    type 'ForemanOmaha::OmahaReport'
  end
end
