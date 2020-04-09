# frozen_string_literal: true

module Types
  module Extensions
    module ForemanOmaha
      module QueryExtensions
        extend ActiveSupport::Concern

        included do
          record_field :omaha_group, Types::OmahaGroup
          collection_field :omaha_groups, Types::OmahaGroup

          record_field :omaha_report, Types::OmahaReport
          collection_field :omaha_reports, Types::OmahaReport
        end
      end
    end
  end
end
