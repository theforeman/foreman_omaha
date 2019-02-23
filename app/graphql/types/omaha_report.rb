# frozen_string_literal: true

module Types
  class OmahaReport < BaseObject
    model_class ::ForemanOmaha::OmahaReport
    description 'An Omaha Report'

    global_id_field :id
    timestamps
    field :status, Types::OmahaReportStatusEnum
    field :omaha_version, String

    belongs_to :host, Types::Host
  end
end
