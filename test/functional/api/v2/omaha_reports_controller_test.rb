require 'test_helper'

class Api::V2::OmahaReportsControllerTest < ActionController::TestCase
  test 'create valid' do
    post :create, { :omaha_report => create_report }, set_session_user
    assert_response :success
  end

  test 'create invalid' do
    post :create, { :omaha_report => ['not a hash', 'throw an error'] }, set_session_user
    assert_response :unprocessable_entity
  end

  test 'should get index' do
    FactoryGirl.create(:omaha_report)
    get :index, {}
    assert_response :success
    assert_not_nil assigns(:omaha_reports)
    reports = ActiveSupport::JSON.decode(@response.body)
    assert !reports['results'].empty?
  end

  test 'should show individual record' do
    report = FactoryGirl.create(:omaha_report)
    get :show, :id => report.to_param
    assert_response :success
    show_response = ActiveSupport::JSON.decode(@response.body)
    assert !show_response.empty?
  end

  test 'should destroy report' do
    report = FactoryGirl.create(:omaha_report)
    assert_difference('ForemanOmaha::OmahaReport.count', -1) do
      delete :destroy, :id => report.to_param
    end
    assert_response :success
    refute Report.find_by(id: report.id)
  end

  test 'should get reports for given host only' do
    report = FactoryGirl.create(:omaha_report)
    get :index, :host_id => report.host.to_param
    assert_response :success
    assert_not_nil assigns(:omaha_reports)
    reports = ActiveSupport::JSON.decode(@response.body)
    assert !reports['results'].empty?
    assert_equal 1, reports['results'].count
  end

  test 'should return empty result for host with no reports' do
    host = FactoryGirl.create(:host)
    get :index, :host_id => host.to_param
    assert_response :success
    assert_not_nil assigns(:omaha_reports)
    reports = ActiveSupport::JSON.decode(@response.body)
    assert reports['results'].empty?
    assert_equal 0, reports['results'].count
  end

  test 'should get last report' do
    reports = FactoryGirl.create_list(:omaha_report, 5)
    get :last, set_session_user
    assert_response :success
    assert_not_nil assigns(:omaha_report)
    report = ActiveSupport::JSON.decode(@response.body)
    assert !report.empty?
    assert_equal reports.last, ForemanOmaha::OmahaReport.find(report['id'])
  end

  test 'should get last report for given host only' do
    main_report = FactoryGirl.create(:omaha_report)
    FactoryGirl.create_list(:omaha_report, 5)
    get :last, { :host_id => main_report.host.to_param }, set_session_user
    assert_response :success
    assert_not_nil assigns(:omaha_report)
    report = ActiveSupport::JSON.decode(@response.body)
    assert !report.empty?
    assert_equal main_report, ForemanOmaha::OmahaReport.find(report['id'])
  end

  test 'should give error if no last report for given host' do
    host = FactoryGirl.create(:host)
    get :last, :host_id => host.to_param
    assert_response :not_found
  end

  test 'cannot view the last report without hosts view permission' do
    report = FactoryGirl.create(:report)
    setup_user('view', 'omaha_reports')
    get :last, { :host_id => report.host.id }, set_session_user.merge(:user => User.current.id)
    assert_response :not_found
  end

  describe 'unpriveliged user' do
    def setup
      User.current = FactoryGirl.create(:user, :admin)
    end

    test 'hosts with a registered smart proxy on should create a report successfully' do
      Setting[:restrict_registered_smart_proxies] = true
      Setting[:require_ssl_smart_proxies] = false

      proxy = FactoryGirl.create(:smart_proxy, :omaha)
      host = URI.parse(proxy.url).host
      Resolv.any_instance.stubs(:getnames).returns([host])
      as_user :one do
        post :create, :omaha_report => create_report
      end
      assert_equal proxy, @controller.detected_proxy
      assert_response :created
    end
  end

  private

  def create_report
    {
      'host' => 'test.example.com',
      'status' => 'downloading',
      'omaha_version' => '1068.9.0',
      'reported_at' => Time.now.utc.to_s
    }
  end
end
