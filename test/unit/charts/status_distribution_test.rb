# frozen_string_literal: true

require 'test_plugin_helper'

module ForemanOmaha
  module Charts
    class StatusDistribitionTest < ActiveSupport::TestCase
      setup do
        User.current = FactoryBot.create(:user, :admin)
      end

      let(:status_distribition_chart) { ForemanOmaha::Charts::StatusDistribution.new }

      context 'with hosts' do
        setup do
          FactoryBot.create_list(:host, 5, :with_omaha_facet)
          FactoryBot.create_list(:host, 3, :with_omaha_facet, :omaha_status => 2)
        end

        test 'calculates the status distribution' do
          expected = [
            { :label => 'Complete', :data => 5, :color => '#89A54E' },
            { :label => 'Downloading', :data => 3, :color => '#3D96AE' }
          ]
          assert_equal(expected, status_distribition_chart.to_chart_data.sort_by { |e| e[:label] })
        end
      end
    end
  end
end
