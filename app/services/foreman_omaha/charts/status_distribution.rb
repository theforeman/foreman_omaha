# frozen_string_literal: true

module ForemanOmaha
  module Charts
    class StatusDistribution
      attr_accessor :hosts

      def initialize(hosts = nil)
        @hosts = hosts || Host.authorized(:view_hosts, Host).joins(:omaha_facet)
      end

      def query
        @query ||= hosts.group(:status).count.transform_keys { |k| ForemanOmaha::OmahaFacet.statuses.key(k).to_sym }
      end

      def to_chart_data
        query.map do |status, count|
          [status_label(status), count]
        end
      end

      def to_a
        query.map do |status, count|
          {
            :status => status,
            :label => status_label(status),
            :count => count
          }
        end
      end

      private

      def color_map
        {
          :unknown => '#92A8CD',
          :complete => '#89A54E',
          :downloading => '#3D96AE',
          :downloaded => '#4572A7',
          :installed => '#DB843D',
          :instance_hold => '#80699B',
          :error => '#AA4643'
        }
      end

      def status_color(status)
        color_map[status]
      end

      def status_label(status)
        ForemanOmaha::StatusMapper.new(status).to_label
      end
    end
  end
end
