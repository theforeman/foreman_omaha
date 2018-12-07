require 'test_plugin_helper'

module ForemanOmaha
  module Charts
    class StatusDistribitionTest < ActiveSupport::TestCase
      setup do
        User.current = FactoryBot.create(:user, :admin)
      end

      let(:omaha_group) { FactoryBot.create(:omaha_group) }
      let(:status_distribition_chart) { ForemanOmaha::Charts::StatusDistribution.new(omaha_group) }

      context 'with hosts' do
        setup do
          FactoryBot.create_list(:host, 5, :with_omaha_facet, omaha_group: omaha_group)
          FactoryBot.create_list(:host, 3, :with_omaha_facet, omaha_status: 2, omaha_group: omaha_group)
        end

        test 'calculates the status distribution' do
          expected = [['Complete', 5, '#89A54E'], ['Downloading', 3, '#3D96AE']].sort_by(&:first)
          actual = JSON.parse(status_distribition_chart.to_chart_data)['columns'].sort_by(&:first)

          assert_equal expected, actual
        end
      end
    end
  end
end
