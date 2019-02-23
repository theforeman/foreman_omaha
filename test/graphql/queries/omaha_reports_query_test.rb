# frozen_string_literal: true

require 'test_plugin_helper'

module Queries
  class OmahaReportsQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query omahaReportsQuery {
        omahaReports {
          totalCount
          pageInfo {
            startCursor
            endCursor
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
              status
              omahaVersion
            }
          }
        }
      }
      GRAPHQL
    end

    let(:data) { result['data']['omahaReports'] }

    setup do
      FactoryBot.create_list(:omaha_report, 2)
    end

    test 'fetching omaha reports attributes' do
      assert_empty result['errors']

      expected_count = ForemanOmaha::OmahaReport.count

      assert_not_equal 0, expected_count
      assert_equal expected_count, data['totalCount']
      assert_equal expected_count, data['edges'].count
    end
  end
end
