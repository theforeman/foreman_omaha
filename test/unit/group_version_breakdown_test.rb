# frozen_string_literal: true

require 'test_plugin_helper'

class CurrentVersionBreakdownTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryBot.create(:user, :admin)
  end

  let(:stable_group) { FactoryBot.create(:omaha_group, :uuid => 'stable', :name => 'Stable') }
  let(:beta_group) { FactoryBot.create(:omaha_group, :uuid => 'beta', :name => 'Beta') }
  let(:group_version_breakdown) { ForemanOmaha::GroupVersionBreakdown.new(:omaha_group => stable_group) }
  let(:stable_releases) { ['1520.6.0', '1520.5.0', '1465.8.0'] }
  let(:beta_coreos) { create_coreos_os('1576.3.0', 'beta') }

  context 'with hosts' do
    setup do
      oslist = stable_releases.map do |release|
        create_coreos_os(release)
      end
      FactoryBot.create_list(
        :host, 2, :managed, :with_omaha_facet,
        :omaha_version => oslist.first.release,
        :omaha_group => stable_group,
        :operatingsystem => oslist.first
      )
      FactoryBot.create(
        :host, :managed, :with_omaha_facet,
        :omaha_version => oslist.last.release,
        :omaha_group => stable_group,
        :operatingsystem => oslist.last
      )
      FactoryBot.create(
        :host, :managed, :with_omaha_facet,
        :omaha_version => beta_coreos.release,
        :omaha_group => beta_group,
        :operatingsystem => beta_coreos
      )
    end

    test 'counts host in stable group' do
      assert_equal 3, group_version_breakdown.facets.count
    end

    test 'calculates a version breakdown' do
      expected = [
        { :version => '1520.6.0', :count => 2, :percentage => 66.67 },
        { :version => '1465.8.0', :count => 1, :percentage => 33.33 }
      ]
      assert_equal expected, group_version_breakdown.version_breakdown
    end
  end

  private

  def create_coreos_os(version, channel = 'stable')
    semver = Gem::Version.new(version)
    FactoryBot.create(
      :coreos,
      :with_associations,
      :major => semver.segments.first,
      :minor => semver.segments.last(2).join('.'),
      :release_name => channel,
      :title => "CoreOS #{version}"
    )
  end
end
