# frozen_string_literal: true

module ForemanOmaha
  module Types
    class OmahaGroup < ::Types::BaseObject
      model_class ForemanOmaha::OmahaGroup
      description 'An Omaha Group'

      global_id_field :id
      timestamps
      field :name, String
      field :uuid, String

      has_many :hosts, ::Types::Host

      def self.graphql_definition
        super.tap { |type| type.instance_variable_set(:@name, 'ForemanOmaha::OmahaGroup') }
      end
    end
  end
end
