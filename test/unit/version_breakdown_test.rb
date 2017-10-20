require 'test_plugin_helper'

class VersionBreakdownTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryGirl.create(:user, :admin)
  end

  let(:version_breakdown) { ForemanOmaha::VersionBreakdown.new }

  context 'with omaha reports' do
    setup do
      # Setup some fake Omaha Reports to calculate a version breakdown
      hosts = FactoryGirl.create_list(:host, 2, :managed)
      versions = ['1235.6.0', '1465.7.0']
      (0..48).each do |hour|
        hosts.each_with_index do |host, idx|
          version = if hour < 24
                      versions[idx]
                    else
                      versions.last
                    end
          reported = '2017-10-17'.to_date + hour.hours
          FactoryGirl.create(:omaha_report, :host => host, :reported_at => reported, :omaha_version => version)
        end
      end
    end

    test 'lists unique versions' do
      assert_equal ['1235.6.0', '1465.7.0'], version_breakdown.versions.sort
    end

    test 'calculates a version breakdown' do
      expected = [
        { :'1465.7.0' => 1, :'1235.6.0' => 1, :date => '2017-10-17' },
        { :'1465.7.0' => 2, :'1235.6.0' => 0, :date => '2017-10-18' },
        { :'1465.7.0' => 2, :'1235.6.0' => 0, :date => '2017-10-19' }
      ]
      assert_equal expected, version_breakdown.to_a
    end
  end
end
