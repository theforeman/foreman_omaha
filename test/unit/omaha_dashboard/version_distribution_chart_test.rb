require 'test_plugin_helper'

module ForemanOmaha
  module OmahaDashboard
    class VersionDistributionChartTest < ActiveSupport::TestCase
      let(:version_distribition_chart) { ForemanOmaha::OmahaDashboard::VersionDistributionChart.new }

      context 'with omaha reports' do
        setup do
          hosts = FactoryGirl.create_list(:host, 2, :managed)
          versions = ['1235.6.0', '1465.7.0']
          hosts.each_with_index do |host, idx|
            version = versions[idx]
            reported = '2017-10-17'.to_date
            FactoryGirl.create(:omaha_report, :host => host, :reported_at => reported, :omaha_version => version)
          end
        end

        test 'calculates the version distribution' do
          expected = [
            ['1235.6.0', 1],
            ['1465.7.0', 1]
          ]
          assert_equal expected, JSON.parse(version_distribition_chart.to_json)
        end
      end
    end
  end
end
