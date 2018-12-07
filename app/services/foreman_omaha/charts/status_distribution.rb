module ForemanOmaha
  module Charts
    class StatusDistribution < Base
      COLOR_MAP = {
        unknown: '#92A8CD',
        complete: '#89A54E',
        downloading: '#3D96AE',
        downloaded: '#4572A7',
        installed: '#DB843D',
        instance_hold: '#80699B',
        error: '#AA4643'
      }.freeze

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

      attr_reader :search

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
