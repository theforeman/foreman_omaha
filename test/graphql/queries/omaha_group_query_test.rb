# frozen_string_literal: true

require 'test_plugin_helper'

module Queries
  class OmahaGroupQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query omahaGroupQuery (
        $id: String!
      ) {
        omahaGroup(id: $id) {
          id
          name
          uuid
          createdAt
          updatedAt
          hosts {
            totalCount
            edges {
              node {
                id
              }
            }
          }
        }
      }
      GRAPHQL
    end

    let(:omaha_group) { FactoryBot.create(:omaha_group) }
    let(:global_id) { Foreman::GlobalId.for(omaha_group) }
    let(:variables) { { id: global_id } }
    let(:data) { result['data']['omahaGroup'] }

    test 'fetching omaha group attributes' do
      FactoryBot.create(:host, :managed, :with_omaha_facet, omaha_group: omaha_group)

      assert_empty result['errors']
      assert_not_nil data

      assert_equal global_id, data['id']
      assert_equal omaha_group.created_at.utc.iso8601, data['createdAt']
      assert_equal omaha_group.updated_at.utc.iso8601, data['updatedAt']
      assert_equal omaha_group.name, data['name']
      assert_equal omaha_group.uuid, data['uuid']

      assert_collection omaha_group.hosts, data['hosts'], type_name: 'Host'
    end
  end
end
