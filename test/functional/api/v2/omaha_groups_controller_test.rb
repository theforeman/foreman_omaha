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
end
