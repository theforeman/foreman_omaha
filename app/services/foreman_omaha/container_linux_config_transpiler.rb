# frozen_string_literal: true

require 'open3'

module ForemanOmaha
  class ContainerLinuxConfigTranspiler
    class TranspilerNotFound < StandardError; end

    class TranspileError < StandardError; end

    attr_accessor :input, :output, :errors, :status

    def initialize(input)
      self.input = input
    end

    def run!
      check_transpiler
      transpile
      raise TranspileError, "Could not transpile container linux config to ignition: #{errors}" unless status.success?

      output
    end

    def transpile
      self.output, self.errors, self.status = Open3.capture3(cmd, :stdin_data => input)
    end

    def check_transpiler
      raise TranspilerNotFound, 'The ct binary was not found in your PATH.' if cmd.blank?
    end

    def cmd
      @cmd ||= Foreman::Util.which('ct')
    end
  end
end
