require 'test_plugin_helper'

module ForemanOmaha
  module Charts
    class OemDistribitionTest < ActiveSupport::TestCase
      setup do
        User.current = FactoryBot.create(:user, :admin)
      end

      let(:omaha_group) { FactoryBot.create(:omaha_group) }
      let(:oem_distribition_chart) { ForemanOmaha::Charts::OemDistribution.new(omaha_group) }

      context 'with hosts' do
        setup do
          FactoryBot.create_list(:host, 5, :with_omaha_facet, omaha_group: omaha_group)
        end

        test 'calculates the oem distribution' do
          expected = [['rackspace', 5]].sort_by(&:first)
          actual = JSON.parse(oem_distribition_chart.to_chart_data)['columns'].sort_by(&:first)

          assert_equal expected, actual
        end

        test 'returns search paths' do
          omaha_group_name = omaha_group.name.tr(' ', '+')
          expected = {
            'rackspace' => "/hosts?search=omaha_group+%3D+%22#{omaha_group_name}%22+and+omaha_oem+%3D+%22rackspace%22"
          }.sort
          actual = JSON.parse(oem_distribition_chart.to_chart_data)['search'].sort

          assert_equal expected, actual
        end
      end
    end
  end
end
