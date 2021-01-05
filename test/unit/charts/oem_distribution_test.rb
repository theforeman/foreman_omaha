# frozen_string_literal: true

require 'test_plugin_helper'

module ForemanOmaha
  module Charts
    class OemDistribitionTest < ActiveSupport::TestCase
      setup do
        User.current = FactoryBot.create(:user, :admin)
      end

      let(:oem_distribition_chart) { ForemanOmaha::Charts::OemDistribution.new }

      context 'with hosts' do
        setup do
          FactoryBot.create_list(:host, 5, :with_omaha_facet)
        end

        test 'calculates the oem distribution' do
          expected = [['rackspace', 5]]
          assert_same_elements expected, oem_distribition_chart.to_chart_data
        end
      end
    end
  end
end
