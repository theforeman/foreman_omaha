# frozen_string_literal: true

require 'test_plugin_helper'

class OmahaHostsControllerTest < ActionController::TestCase
  test '#index' do
    FactoryBot.create(:host, :with_omaha_facet)
    get :index, session: set_session_user
    assert_response :success
    assert_not_nil assigns('hosts')
    assert_template 'index'
  end
end
