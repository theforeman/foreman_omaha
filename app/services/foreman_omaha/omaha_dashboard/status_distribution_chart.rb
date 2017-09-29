module ForemanOmaha
  module OmahaDashboard
    class StatusDistributionChart
      def query
        Host.joins("INNER JOIN (#{sub2.to_sql}) sub2 ON sub2.host_id = hosts.id").group(:status).count.transform_keys { |k| ForemanOmaha::OmahaReport.statuses.key(k).to_sym }
      end

      def sub1
        ForemanOmaha::OmahaReport.select(:host_id, 'MAX(reported_at) AS reported_at').group(:host_id)
      end

      def sub2
        ForemanOmaha::OmahaReport.select(:host_id, :status, :reported_at).joins("INNER JOIN (#{sub1.to_sql}) sub1 ON sub1.host_id = reports.host_id AND sub1.reported_at = reports.reported_at")
      end

      # data compatible for non react charts
      def to_a
        query.map do |status, count|
          {
            :label => status_label(status),
            :data => count,
            :color => status_color(status)
          }
        end
      end

      # data compatible for react charts
      def to_json
        query.map do |status, count|
          [status_label(status), count, status_color(status)]
        end.to_json
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
        ForemanOmaha::OmahaReport.to_label(status)
      end
    end
  end
end
