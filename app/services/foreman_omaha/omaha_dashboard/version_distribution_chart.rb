module ForemanOmaha
  module OmahaDashboard
    class VersionDistributionChart
      def query
        Host.joins("INNER JOIN (#{subquery.to_sql}) subquery ON subquery.host_id = hosts.id").group(:omaha_version).count
      end

      def subquery
        ForemanOmaha::OmahaReport.select(:host_id, 'MAX(omaha_version) AS omaha_version').group(:host_id)
      end

      def to_a
        query.to_a.sort_by { |entry| Gem::Version.new(entry[0]) }
      end

      # data compatible for non react charts
      def to_chart_data
        query.map do |version, count|
          {
            :label => version,
            :data => count
          }
        end
      end

      # data compatible for react charts
      def to_json
        to_a.to_json
      end
    end
  end
end
