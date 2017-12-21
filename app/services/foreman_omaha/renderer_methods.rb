module ForemanOmaha
  module RendererMethods
    def transpile_container_linux_config(input)
      ForemanOmaha::ContainerLinuxConfigTranspiler.new(input).run!
    end
  end
end
