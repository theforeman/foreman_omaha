module ForemanOmaha
  module Charts
    class StatusDistribution < Base
      # use colors from pf color palette
      # https://www.patternfly.org/styles/color-palette/
      COLOR_MAP = {
        unknown: 'blue-200',
        complete: 'green',
        downloading: 'cyan',
        downloaded: 'blue',
        installed: 'orange',
        instance_hold: 'purple-300',
        error: 'red'
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
