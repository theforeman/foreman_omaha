require 'test_plugin_helper'

class HostTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryBot.create(:user, :admin)
  end

  context 'scoped search' do
    setup do
      @host = FactoryBot.create(:host, :with_omaha_facet)
    end

    test 'search by last_report' do
      hosts = Host.search_for('last_omaha_report = Today')
      assert_includes hosts, @host
    end

    test 'search by machineid' do
      hosts = Host.search_for("omaha_machineid = #{@host.omaha_facet.machineid}")
      assert_includes hosts, @host
    end

    test 'search by version' do
      hosts = Host.search_for("omaha_version = #{@host.omaha_facet.version}")
      assert_includes hosts, @host
    end

    test 'search by oem' do
      hosts = Host.search_for("omaha_oem = #{@host.omaha_facet.oem}")
      assert_includes hosts, @host
    end

    test 'search by status' do
      hosts = Host.search_for("omaha_status = #{@host.omaha_facet.status}")
      assert_includes hosts, @host
    end

    test 'search by omaha_group' do
      hosts = Host.search_for("omaha_group = \"#{@host.omaha_facet.omaha_group.name}\"")
      assert_includes hosts, @host
    end
  end
end
