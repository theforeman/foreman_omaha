# frozen_string_literal: true

require 'test_plugin_helper'

module ForemanOmaha
  module Charts
    class VersionDistribitionTest < ActiveSupport::TestCase
      setup do
        User.current = FactoryBot.create(:user, :admin)
      end

      let(:version_distribition_chart) { ForemanOmaha::Charts::VersionDistribution.new }

      context 'with hosts' do
        setup do
          FactoryBot.create_list(:host, 5, :with_omaha_facet)
          FactoryBot.create_list(:host, 7, :with_omaha_facet, :omaha_version => '1465.7.0')
        end

        test 'calculates the version distribution' do
          expected = [
            { :label => '1068.9.0', :data => 5 },
            { :label => '1465.7.0', :data => 7 }
          ]
          assert_equal(expected, version_distribition_chart.to_chart_data.sort_by { |e| e[:label] })
        end
      end
    end
  end
end
