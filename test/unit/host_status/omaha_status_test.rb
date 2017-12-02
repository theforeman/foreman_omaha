require 'test_plugin_helper'

class OmahaStatusTest < ActiveSupport::TestCase
  let(:host) { FactoryBot.build_stubbed(:host, :with_omaha_facet) }
  let(:status) { HostStatus::OmahaStatus.new }

  setup do
    User.current = FactoryBot.create(:user, :admin)
    status.host = host
  end

  test '#relevant? is only for hosts with an omaha facet' do
    assert_equal true, status.relevant?

    status.host = FactoryBot.build_stubbed(:host)

    assert_equal false, status.relevant?
  end
end
