require 'test_helper'

class OmahaFactsParserTest < ActiveSupport::TestCase
  setup do
    User.current = users(:admin)
  end

  let(:facts) do
    {
      'appid' => 'e96281a6-d1af-4bde-9a0a-97b76e56dc57',
      'version' => '1068.9.0',
      'track' => 'stable',
      'board' => 'amd64-usr',
      'alephversion' => '1010.5.0',
      'oemversion' => '',
      'oem' => '',
      'platform' => 'CoreOS',
      'osmajor' => '1068',
      'osminor' => '9.0',
      'ipaddress' => '127.0.0.1',
      'ipaddress6' => '',
      'hostname' => 'client.example.com'
    }
  end
  let(:importer) { ::ForemanOmaha::FactParser.new(facts) }

  context '#architecture' do
    let(:architecture) { importer.architecture }

    test 'should return an Architecture' do
      assert_kind_of Architecture, architecture
      assert_equal Architecture.find_by(name: 'x86_64'), architecture
    end
  end

  context '#operatingsystem' do
    let(:os) { importer.operatingsystem }

    test 'should return an OS with correct params' do
      assert_kind_of Operatingsystem, os
      assert_equal '1068', os.major
      assert_equal '9.0', os.minor
      assert_equal 'CoreOS', os.name
      assert_equal 'CoreOS 1068.9.0', os.description
      assert_equal 'stable', os.release_name
      assert_empty os.ptables
      assert_empty os.media
      assert_empty os.os_default_templates
    end

    context 'with old versions' do
      setup do
        FactoryBot.create(:coreos,
                          :major => '899',
                          :minor => '17.0',
                          :title => 'CoreOS 899.17.0')
        @previous = FactoryBot.create(:coreos,
                                      :with_associations,
                                      :with_provision,
                                      :major => '1010',
                                      :minor => '5.0',
                                      :title => 'CoreOS 1010.5.0')
      end

      test 'should copy attributes from previous os version' do
        assert_equal '1068', os.major
        assert_equal '9.0', os.minor
        assert_equal @previous.ptables, os.ptables
        assert_equal @previous.architectures, os.architectures
        assert_equal @previous.media, os.media
        assert_equal @previous.os_default_templates.map(&:provisioning_template), os.os_default_templates.map(&:provisioning_template)
        assert_equal @previous.os_default_templates.map(&:template_kind), os.os_default_templates.map(&:template_kind)
        assert_equal @previous.provisioning_templates, os.provisioning_templates
      end
    end
  end
end
