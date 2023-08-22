# frozen_string_literal: true

module ForemanOmaha
  module Types
    class OmahaGroup < ::Types::BaseObject
      graphql_name 'ForemanOmaha_OmahaGroup'
      model_class ForemanOmaha::OmahaGroup
      description 'An Omaha Group'

      global_id_field :id
      timestamps
      field :name, String
      field :uuid, String

      has_many :hosts, ::Types::Host
    end
  end
end
