# frozen_string_literal: true

module ForemanOmaha
  module Charts
    class OemDistribution
      attr_accessor :hosts

      def initialize(hosts = nil)
        @hosts = hosts || Host.authorized(:view_hosts, Host).joins(:omaha_facet)
      end

      def query
        @query ||= hosts.group(:oem).count
      end

      def to_chart_data
        query.map do |oem, count|
          [oem, count]
        end
      end
    end
  end
end
