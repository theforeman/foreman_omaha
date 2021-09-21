# frozen_string_literal: true

module ForemanOmaha
  module TemplateRendererHelper
    def transpile_container_linux_config(input)
      ForemanOmaha::ContainerLinuxConfigTranspiler.new(input).run!
    end
  end
end
