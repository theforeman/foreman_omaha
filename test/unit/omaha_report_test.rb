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
    test 'should import a report' do
      host = FactoryBot.create(:host)
      report = {
        'host' => host.name,
        'status' => 'downloading',
        'omaha_version' => '1068.9.0',
        'reported_at' => Time.now.utc.to_s
      }
      assert_difference('ForemanOmaha::OmahaReport.count') do
        ForemanOmaha::OmahaReport.import(report)
      end
    end

    test 'should not import a report with invalid value' do
      host = FactoryBot.create(:host)
      report = {
        'host' => host.name,
        'status' => 'invalid',
        'omaha_version' => '1068.9.0',
        'reported_at' => Time.now.utc.to_s
      }
      assert_raise ArgumentError do
        ForemanOmaha::OmahaReport.import(report)
      end
    end
  end
end
