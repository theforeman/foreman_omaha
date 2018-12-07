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
          expected = [['rackspace', 5]]
          actual = JSON.parse(oem_distribition_chart.to_chart_data)['columns']

          assert_equal expected, actual
        end
      end
    end
  end
end
