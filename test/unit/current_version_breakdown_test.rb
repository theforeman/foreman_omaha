require 'test_plugin_helper'

class CurrentVersionBreakdownTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryGirl.create(:user, :admin)
  end

  let(:track) { 'stable' }
  let(:current_version_breakdown) { ForemanOmaha::CurrentVersionBreakdown.new(:track => track) }
  let(:stable_releases) { ['1520.6.0', '1520.5.0', '1465.8.0'] }
  let(:beta_coreos) { create_coreos_os('', 'beta') }

  context 'with hosts' do
    setup do
      oslist = stable_releases.map do |release|
        create_coreos_os(release)
      end
      FactoryGirl.create_list(
        :host, 2, :managed,
        :operatingsystem => oslist.first
      )
      FactoryGirl.create(:host, :managed, :operatingsystem => oslist.last)
      FactoryGirl.create(:host, :managed, :operatingsystem => beta_coreos)
    end

    test 'counts host in stable track' do
      assert_equal 3, current_version_breakdown.all
    end

    test 'calculates a version breakdown' do
      expected = [
        { :version => '1520.6.0', :count => 2, :percentage => 66.67 },
        { :version => '1465.8.0', :count => 1, :percentage => 33.33 }
      ]
      assert_equal expected, current_version_breakdown.version_breakdown
    end
  end

  private

  def create_coreos_os(version, channel = 'stable')
    semver = Gem::Version.new(version)
    FactoryGirl.create(
      :coreos,
      :with_associations,
      :major => semver.segments.first,
      :minor => semver.segments.last(2).join('.'),
      :release_name => channel,
      :title => "CoreOS #{version}"
    )
  end
end
