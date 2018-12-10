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
          expected = [['1068.9.0', 5], ['1465.7.0', 7]].sort_by(&:first)
          actual = JSON.parse(version_distribition_chart.to_chart_data)['columns'].sort_by(&:first)

          assert_equal expected, actual
        end

        test 'returns search paths' do
          omaha_group_name = omaha_group.name.tr(' ', '+')
          expected = {
            '1068.9.0' => "/hosts?search=omaha_group+%3D+#{omaha_group_name}+and+omaha_version+%3D+1068.9.0",
            '1465.7.0' => "/hosts?search=omaha_group+%3D+#{omaha_group_name}+and+omaha_version+%3D+1465.7.0"
          }.sort
          actual = JSON.parse(version_distribition_chart.to_chart_data)['search'].sort

          assert_equal expected, actual
        end
      end
    end
  end
end
