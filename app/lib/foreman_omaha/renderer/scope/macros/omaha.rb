# frozen_string_literal: true

module ForemanOmaha
  module Renderer
    module Scope
      module Macros
        module Omaha
          def transpile_container_linux_config(input)
            ForemanOmaha::ContainerLinuxConfigTranspiler.new(input).run!
          end
        end
      end
    end
  end
end
