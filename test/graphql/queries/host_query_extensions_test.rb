# frozen_string_literal: true

require 'test_plugin_helper'

module Queries
  class HostQueryExtensionsTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query (
        $id: String!
      ) {
        host(id: $id) {
          id
          omahaReports {
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

    let(:host) do
      FactoryBot.create(:host, :managed, :with_omaha_reports)
    end
    let(:global_id) { Foreman::GlobalId.encode('Host', host.id) }
    let(:variables) { { id: Foreman::GlobalId.encode('Host', host.id) } }
    let(:data) { result['data']['host'] }

    test 'fetching host attributes with omaha extensions' do
      assert_empty result['errors']
      assert_equal global_id, data['id']

      assert_collection host.omaha_reports, data['omahaReports']
    end
  end
end
