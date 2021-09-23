# frozen_string_literal: true

module ForemanOmaha
  module Types
    class OmahaReport < ::Types::BaseObject
      model_class ForemanOmaha::OmahaReport
      description 'An Omaha Report'

      global_id_field :id
      timestamps
      field :status, ForemanOmaha::Types::OmahaReportStatusEnum
      field :omaha_version, String

      belongs_to :host, ::Types::Host

      def self.graphql_definition
        super.tap { |type| type.instance_variable_set(:@name, 'ForemanOmaha::OmahaReport') }
      end
    end
  end
end
