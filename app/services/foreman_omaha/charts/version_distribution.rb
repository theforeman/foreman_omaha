module ForemanOmaha
  module Charts
    class VersionDistribution < Base
      private

      def query
        @query ||= hosts.group(:version).count
      end

      def columns
        query.map { |version, count| [version, count] }
      end

      def search
        query.map do |version, _count|
          [version, hosts_path(search: "omaha_group = \"#{omaha_group}\" and omaha_version = \"#{version}\"")]
        end.to_h
      end
    end
  end
end
