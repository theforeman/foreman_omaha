require 'test_plugin_helper'

class OmahaGroupsControllerTest < ActionController::TestCase
  test '#index' do
    FactoryBot.create(:omaha_group)
    get :index, session: set_session_user
    assert_response :success
    assert_not_nil assigns('omaha_groups')
    assert_template 'index'
  end
end
