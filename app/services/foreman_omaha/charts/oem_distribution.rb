module ForemanOmaha
  module Charts
    class OemDistribution < Base
      private

      def query
        @query ||= hosts.group(:oem).count
      end

      def columns
        query.map { |oem, count| [oem, count] }
      end

      def search
        query.map do |oem, _count|
          [oem, hosts_path(search: "omaha_group = \"#{omaha_group}\" and omaha_oem = \"#{oem}\"")]
        end.to_h
      end
    end
  end
end
