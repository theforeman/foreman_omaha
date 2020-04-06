# frozen_string_literal: true

require 'test_plugin_helper'

class Api::V2::OmahaGroupsControllerTest < ActionController::TestCase
  context '#index' do
    test 'should list omaha groups' do
      omaha_group = FactoryBot.create(:omaha_group, :name => 'Stable', :uuid => 'stable')
      get :index
      assert_response :success
      body = ActiveSupport::JSON.decode(@response.body)
      results = body['results']
      assert results
      entry = results.detect { |e| e['id'] == omaha_group.id }
      assert entry
      assert_equal omaha_group.name, entry['name']
      assert_equal omaha_group.uuid, entry['uuid']
    end
  end

  context '#show' do
    let(:omaha_group) { FactoryBot.create(:omaha_group) }

    test 'should show individual record' do
      get :show, params: { :id => omaha_group.to_param }
      assert_response :success
      body = ActiveSupport::JSON.decode(@response.body)
      assert_not_empty body
      assert_equal omaha_group.id, body['id']
      assert_equal omaha_group.name, body['name']
      assert_equal omaha_group.uuid, body['uuid']
    end
  end
end
