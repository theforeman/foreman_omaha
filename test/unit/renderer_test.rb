require 'test_plugin_helper'

module ForemanOmaha
  class RendererTest < ActiveSupport::TestCase
    class DummyRenderer
      attr_accessor :host

      include Foreman::Renderer
      include ForemanOmaha::RendererMethods
    end

    let(:renderer) { DummyRenderer.new }

    test 'should transpile a container linux config' do
      expected = '{"ignition":{"config":{},"timeouts":{},"version":"2.1.0"},"networkd":{},"passwd":{},"storage":{},"systemd":{}}'
      ForemanOmaha::ContainerLinuxConfigTranspiler.any_instance.stubs(:run!).returns(expected)
      transpiled = renderer.transpile_container_linux_config('---')
      assert_equal expected, transpiled
    end
  end
end
