# frozen_string_literal: true

module Types
  class OmahaReportStatusEnum < BaseEnum
    ForemanOmaha::OmahaFacet::VALID_OMAHA_STATUSES.each do |status|
      value status
    end
  end
end
