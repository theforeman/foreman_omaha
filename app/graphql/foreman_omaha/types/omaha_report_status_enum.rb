# frozen_string_literal: true

module ForemanOmaha
  module Types
    class OmahaReportStatusEnum < ::Types::BaseEnum
      ForemanOmaha::OmahaFacet::VALID_OMAHA_STATUSES.each do |status|
        value status
      end
    end
  end
end
