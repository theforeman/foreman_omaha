# frozen_string_literal: true

module ForemanOmaha
  module Types
    class OmahaReport < ::Types::BaseObject
      graphql_name 'ForemanOmaha_OmahaReport'
      model_class ForemanOmaha::OmahaReport
      description 'An Omaha Report'

      global_id_field :id
      timestamps
      field :status, ForemanOmaha::Types::OmahaReportStatusEnum
      field :omaha_version, String

      belongs_to :host, ::Types::Host
    end
  end
end
