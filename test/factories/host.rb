# frozen_string_literal: true

FactoryBot.modify do
  factory :host do
    trait :with_omaha_facet do
      association :omaha_facet, :factory => :omaha_facet, :strategy => :build

      transient do
        omaha_status { 1 }
        omaha_version { '1068.9.0' }
        omaha_oem { 'rackspace' }
        omaha_group { nil }
      end

      after(:build) do |host, evaluator|
        host.omaha_facet.status = evaluator.omaha_status
        host.omaha_facet.version = evaluator.omaha_version
        host.omaha_facet.oem = evaluator.omaha_oem
        host.omaha_facet.omaha_group = evaluator.omaha_group if evaluator.omaha_group.present?
      end
    end

    trait :with_omaha_reports do
      with_omaha_facet
      transient do
        omaha_report_count { 5 }
      end
      after(:create) do |host, evaluator|
        evaluator.omaha_report_count.times do |i|
          FactoryBot.create(:omaha_report, host: host, reported_at: (evaluator.omaha_report_count - i).minutes.ago)
        end
        host.omaha_facet.update_attribute(:last_report, host.omaha_reports.last.reported_at) # rubocop:disable Rails/SkipsModelValidations
      end
    end
  end
end
