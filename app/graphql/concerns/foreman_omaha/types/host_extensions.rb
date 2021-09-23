# frozen_string_literal: true

module ForemanOmaha
  module Types
    module HostExtensions
      extend ActiveSupport::Concern

      included do
        has_many :omaha_reports, ForemanOmaha::Types::OmahaReport
      end
    end
  end
end
