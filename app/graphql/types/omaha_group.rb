# frozen_string_literal: true

module Types
  class OmahaGroup < BaseObject
    model_class ::ForemanOmaha::OmahaGroup
    description 'An Omaha Group'

    global_id_field :id
    timestamps
    field :name, String
    field :uuid, String

    has_many :hosts, Types::Host
  end
end
