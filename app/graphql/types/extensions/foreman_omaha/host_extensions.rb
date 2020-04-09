# frozen_string_literal: true

module Types
  module Extensions
    module ForemanOmaha
      module HostExtensions
        extend ActiveSupport::Concern

        included do
          has_many :omaha_reports, Types::OmahaReport
        end
      end
    end
  end
end
