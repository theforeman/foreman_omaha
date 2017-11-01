require 'test_plugin_helper'

class OmahaReportTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryBot.create(:user, :admin)
  end

  context 'status' do
    let(:report) { FactoryBot.build(:omaha_report) }

    test 'should be complete' do
      report.status = 'complete'
      assert_equal 'complete', report.status
      assert_equal 'Complete', report.to_label
    end

    test 'should be downloading' do
      report.status = 'downloading'
      assert_equal 'downloading', report.status
      assert_equal 'Downloading', report.to_label
    end

    test 'should be downloaded' do
      report.status = 'downloaded'
      assert_equal 'downloaded', report.status
      assert_equal 'Downloaded', report.to_label
    end

    test 'should be installed' do
      report.status = 'installed'
      assert_equal 'installed', report.status
      assert_equal 'Installed', report.to_label
    end

    test 'should be installed' do
      report.status = 'instance_hold'
      assert_equal 'instance_hold', report.status
      assert_equal 'Instance Hold', report.to_label
    end

    test 'should be error' do
      report.status = 'error'
      assert_equal 'error', report.status
      assert_equal 'Error', report.to_label
    end
  end

  context 'operatingsystem' do
    let(:os) { FactoryBot.create(:coreos, :major => '1068', :minor => '9.0') }
    let(:report) { FactoryBot.create(:omaha_report) }

    test 'should get operatingsystem' do
      assert_equal os, report.operatingsystem
    end

    test 'should parse major, minor' do
      assert_equal '1068', report.osmajor
      assert_equal '9.0', report.osminor
    end
  end

  context '#import' do
    let(:host) { FactoryBot.create(:host) }
    let(:group) { FactoryBot.create(:omaha_group, :name => 'Stable', :uuid => 'stable') }
    let(:report_data) do
      {
        'host' => host.name,
        'status' => 'downloading',
        'omaha_version' => '494.5.0',
        'omaha_group' => 'stable',
        'machineid' => '8e9450f47a4c47adbfe48b946e201c84',
        'oem' => 'rackspace',
        'reported_at' => Time.now.utc.to_s
      }
    end

    test 'should import a report' do
      assert_difference('ForemanOmaha::OmahaReport.count') do
        ForemanOmaha::OmahaReport.import(report_data)
      end
    end

    test 'should not import a report with invalid value' do
      report_data['status'] = 'invalid'
      assert_raise ArgumentError do
        ForemanOmaha::OmahaReport.import(report_data)
      end
    end

    test 'should create host omaha facet' do
      assert_nil host.omaha_facet
      assert_not_nil group
      ForemanOmaha::OmahaReport.import(report_data)
      facet = host.reload.omaha_facet
      assert_not_nil facet
      assert_equal host, facet.host
      assert_equal report_data['reported_at'].to_date, facet.last_report.to_date
      assert_equal report_data['status'], facet.status
      assert_equal report_data['machineid'], facet.machineid
      assert_equal report_data['oem'], facet.oem
      assert_equal report_data['omaha_version'], facet.version
      assert_equal group, facet.omaha_group
    end

    test 'should update host omaha facet' do
      assert_not_nil group
      ForemanOmaha::OmahaReport.import(report_data)
      time = Time.now.advance(seconds: 10).utc.to_s
      new_report = report_data.merge(
        'status' => 'complete',
        'reported_at' => time,
        'omaha_version' => '1068.9.0'
      ).except('host')
      ForemanOmaha::OmahaReport.import(new_report)
      facet = host.reload.omaha_facet
      assert_not_nil facet
      assert_equal host, facet.host
      assert_equal time.to_date, facet.last_report.to_date
      assert_equal 'complete', facet.status
      assert_equal new_report['machineid'], facet.machineid
      assert_equal 'rackspace', facet.oem
      assert_equal '1068.9.0', facet.version
      assert_equal group, facet.omaha_group
    end

    test 'should detect omaha group by os version' do
      assert_not_nil group
      FactoryBot.create(:coreos)
      ForemanOmaha::OmahaReport.import(report_data.except('omaha_group'))
      facet = host.reload.omaha_facet
      assert_not_nil facet
      assert_equal group, facet.omaha_group
    end
  end
end
