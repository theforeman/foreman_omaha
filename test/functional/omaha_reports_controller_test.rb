require 'test_plugin_helper'

class OmahaReportsControllerTest < ActionController::TestCase
  test '#index' do
    FactoryBot.create(:omaha_report)
    get :index, {}, set_session_user
    assert_response :success
    assert_not_nil assigns('omaha_reports')
    assert_template 'index'
  end

  test '#show' do
    report = FactoryBot.create(:omaha_report)
    get :show, { :id => report.id }, set_session_user
    assert_template 'show'
  end

  test '404 on #show when id is blank' do
    get :show, { :id => ' ' }, set_session_user
    assert_response :missing
    assert_template 'common/404'
  end

  test '#show last' do
    FactoryBot.create(:omaha_report)
    get :show, { :id => 'last' }, set_session_user
    assert_template 'show'
  end

  test '404 on #show last when no reports available' do
    get :show, { :id => 'last', :host_id => FactoryBot.create(:host) }, set_session_user
    assert_response :missing
    assert_template 'common/404'
  end

  test '#show last report for host' do
    report = FactoryBot.create(:omaha_report)
    get :show, { :id => 'last', :host_id => report.host.to_param }, set_session_user
    assert_template 'show'
  end

  test 'render 404 when #show invalid report for a host is requested' do
    get :show, { :id => 'last', :host_id => 'blalala.domain.com' }, set_session_user
    assert_response :missing
    assert_template 'common/404'
  end

  test '#destroy' do
    report = FactoryBot.create(:omaha_report)
    delete :destroy, { :id => report }, set_session_user
    assert_redirected_to omaha_reports_url
    assert !ConfigReport.exists?(report.id)
  end
end
