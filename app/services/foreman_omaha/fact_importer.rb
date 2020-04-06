# frozen_string_literal: true

module ForemanOmaha
  class FactImporter < ::FactImporter
    def self.authorized_smart_proxy_features
      'Omaha'
    end

    def fact_name_class
      ForemanOmaha::FactName
    end
  end
end
