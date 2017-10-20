module ForemanOmaha
  module OmahaDashboard
    class VersionDistributionChart
      def query
        Host.joins("INNER JOIN (#{subquery.to_sql}) subquery ON subquery.host_id = hosts.id").group(:omaha_version).count
      end

      def subquery
        ForemanOmaha::OmahaReport.select(:host_id, 'MAX(omaha_version) AS omaha_version').group(:host_id)
      end

      def to_json
        query.to_a.to_json
      end
    end
  end
end
