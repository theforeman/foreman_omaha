module ForemanOmaha
  module Charts
    class StatusDistribution
      COLOR_MAP = {
        unknown: '#92A8CD',
        complete: '#89A54E',
        downloading: '#3D96AE',
        downloaded: '#4572A7',
        installed: '#DB843D',
        instance_hold: '#80699B',
        error: '#AA4643'
      }.freeze

      def initialize(omaha_group)
        @omaha_group = omaha_group
      end

      def to_chart_data
        {
          columns: columns
        }.to_json
      end

      def to_a
        query.map do |status, count|
          {
            status: status,
            label: status_label(status),
            count: count
          }
        end
      end

      private

      attr_accessor :omaha_group
      delegate :hosts, to: :omaha_group
      delegate :hosts_path, to: 'Rails.application.routes.url_helpers'

      def query
        @query ||= hosts.group(:status).count.transform_keys { |k| ForemanOmaha::OmahaFacet.statuses.key(k).to_sym }
      end

      def columns
        query.map { |status, count| [status_label(status), count, COLOR_MAP[status]] }
      end

      def status_label(status)
        ForemanOmaha::StatusMapper.new(status).to_label
      end
    end
  end
end
