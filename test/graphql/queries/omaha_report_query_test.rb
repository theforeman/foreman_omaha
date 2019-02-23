# frozen_string_literal: true

require 'test_plugin_helper'

module Queries
  class OmahaReportQueryTest < GraphQLQueryTestCase
    let(:query) do
      <<-GRAPHQL
      query omahaReportQuery (
        $id: String!
      ) {
        omahaReport(id: $id) {
          id
          status
          omahaVersion
          createdAt
          updatedAt
          host {
            id
          }
        }
      }
      GRAPHQL
    end

    let(:omaha_report) { FactoryBot.create(:omaha_report) }
    let(:global_id) { Foreman::GlobalId.for(omaha_report) }
    let(:variables) { { id: global_id } }
    let(:data) { result['data']['omahaReport'] }

    test 'fetching omaha report attributes' do
      assert_empty result['errors']
      assert_not_nil data

      assert_equal global_id, data['id']
      assert_equal omaha_report.created_at.utc.iso8601, data['createdAt']
      assert_equal omaha_report.updated_at.utc.iso8601, data['updatedAt']
      assert_equal omaha_report.status, data['status']
      assert_equal omaha_report.omaha_version, data['omahaVersion']

      assert_record omaha_report.host, data['host']
    end
  end
end
