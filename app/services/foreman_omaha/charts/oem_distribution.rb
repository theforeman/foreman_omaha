module ForemanOmaha
  module Charts
    class OemDistribution
      def initialize(omaha_group)
        @omaha_group = omaha_group
      end

      def to_chart_data
        {
          search: search,
          columns: columns
        }.to_json
      end

      private

      attr_accessor :omaha_group
      delegate :hosts, to: :omaha_group
      delegate :hosts_path, to: 'Rails.application.routes.url_helpers'

      def query
        @query ||= hosts.group(:oem).count
      end

      def columns
        query.map { |oem, count| [oem, count] }
      end

      def search
        query.map do |oem, _count|
          [oem, hosts_path(search: "omaha_group = #{omaha_group} and omaha_oem = #{oem}")]
        end.to_h
      end
    end
  end
end
