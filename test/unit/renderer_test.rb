require 'test_plugin_helper'

module ForemanOmaha
  class RendererTest < ActiveSupport::TestCase
    let(:host) { FactoryBot.create(:host) }
    let(:template) { OpenStruct.new(name: 'abc', template: "<%= transpile_container_linux_config('---') %>") }
    let(:source) { Foreman::Renderer::Source::Database.new(template) }
    let(:scope) { Foreman::Renderer::Scope::Base.new(host: host, source: source) }
    let(:expected) { '{"ignition":{"config":{},"timeouts":{},"version":"2.1.0"},"networkd":{},"passwd":{},"storage":{},"systemd":{}}' }

    setup do
      ForemanOmaha::ContainerLinuxConfigTranspiler.any_instance.stubs(:run!).returns(expected)
    end

    context 'with safe mode renderer' do
      let(:renderer) { Foreman::Renderer::SafeModeRenderer }

      test 'should transpile a container linux config' do
        assert_equal expected, renderer.render(source, scope)
      end
    end

    context 'with unsafe mode renderer' do
      let(:renderer) { Foreman::Renderer::UnsafeModeRenderer }

      test 'should transpile a container linux config' do
        assert_equal expected, renderer.render(source, scope)
      end
    end
  end
end
