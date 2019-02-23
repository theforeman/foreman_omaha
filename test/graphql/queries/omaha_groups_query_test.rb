# frozen_string_literal: true

require 'test_plugin_helper'

module Queries
  class OmahaGroupsQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query omahaGroupsQuery {
        omahaGroups {
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
              name
              uuid
            }
          }
        }
      }
      GRAPHQL
    end

    let(:data) { result['data']['omahaGroups'] }

    setup do
      FactoryBot.create_list(:omaha_group, 2)
    end

    test 'fetching models attributes' do
      assert_empty result['errors']

      expected_count = ForemanOmaha::OmahaGroup.count

      assert_not_equal 0, expected_count
      assert_equal expected_count, data['totalCount']
      assert_equal expected_count, data['edges'].count
    end
  end
end
