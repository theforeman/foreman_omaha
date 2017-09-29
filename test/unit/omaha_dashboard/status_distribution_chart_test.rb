require 'test_plugin_helper'

module ForemanOmaha
  module OmahaDashboard
    class StatusDistributionChartTest < ActiveSupport::TestCase
      let(:status_distribition_chart) { ForemanOmaha::OmahaDashboard::StatusDistributionChart.new }

      context 'with omaha reports' do
        setup do
          hosts = FactoryGirl.create_list(:host, 5, :managed)
          report_times = (0..4).map do |hours_ago|
            '2017-10-17'.to_date - hours_ago.hours
          end
          hosts.each_with_index do |host, host_idx|
            version = '1465.7.0'
            report_times.each_with_index do |reported_at, report_idx|
              status = report_idx.zero? && host_idx > 2 ? :downloading : :complete
              FactoryGirl.create(
                :omaha_report,
                :status => status,
                :host => host,
                :reported_at => reported_at,
                :omaha_version => version
              )
            end
          end
        end

        test 'calculates the status distribution' do
          expected = [
            ['Complete', 3, '#89A54E'],
            ['Downloading', 2, '#3D96AE']
          ]
          assert_equal expected, JSON.parse(status_distribition_chart.to_json)
        end
      end
    end
  end
end
