require 'test_plugin_helper'

module ForemanOmaha
  module Charts
    class VersionDistribitionTest < ActiveSupport::TestCase
      setup do
        User.current = FactoryBot.create(:user, :admin)
      end

      let(:omaha_group) { FactoryBot.create(:omaha_group) }
      let(:version_distribition_chart) { ForemanOmaha::Charts::VersionDistribution.new(omaha_group) }

      context 'with hosts' do
        setup do
          FactoryBot.create_list(:host, 5, :with_omaha_facet, omaha_group: omaha_group)
          FactoryBot.create_list(:host, 7, :with_omaha_facet, omaha_version: '1465.7.0', omaha_group: omaha_group)
        end

        test 'calculates the version distribution' do
          expected = [['1068.9.0', 5], ['1465.7.0', 7]]
          actual = JSON.parse(version_distribition_chart.to_chart_data)['columns']

          assert_equal expected, actual
        end
      end
    end
  end
end
