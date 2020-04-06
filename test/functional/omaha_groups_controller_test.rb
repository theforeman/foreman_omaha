# frozen_string_literal: true

require 'test_plugin_helper'

class OmahaGroupsControllerTest < ActionController::TestCase
  test '#index' do
    FactoryBot.create(:omaha_group)
    get :index, session: set_session_user
    assert_response :success
    assert_not_nil assigns('omaha_groups')
    assert_template 'index'
  end

  test '#show' do
    omaha_group = FactoryBot.create(:omaha_group)
    get :show, params: { :id => omaha_group.id }, session: set_session_user
    assert_response :success
    assert_template 'show'
  end
end
