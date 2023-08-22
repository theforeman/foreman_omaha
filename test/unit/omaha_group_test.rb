# frozen_string_literal: true

require 'test_plugin_helper'

class OmahaGroupTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryBot.create(:user, :admin)
  end

  let(:omaha_group) { FactoryBot.create(:omaha_group, :uuid => 'stable', :name => 'Stable') }
  let(:releases) { ['1520.5.0', '1520.6.0', '1465.8.0'].map { |release| Gem::Version.new(release) } }
  let(:operatingsystems) do
    releases.map do |semver|
      FactoryBot.create(
        :coreos,
        :with_associations,
        :major => semver.segments.first,
        :minor => semver.segments.last(2).join('.'),
        :release_name => 'stable',
        :title => "CoreOS #{semver}"
      )
    end
  end

  context 'with operatingsystems' do
    setup do
      operatingsystems
    end

    test 'return latest operating system' do
      latest_operatingsystem = omaha_group.latest_operatingsystem

      assert_equal '1520', latest_operatingsystem.major
      assert_equal '6.0', latest_operatingsystem.minor
    end
  end
end
