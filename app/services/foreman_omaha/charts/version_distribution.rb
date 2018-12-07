module ForemanOmaha
  module Charts
    class VersionDistribution
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
        @query ||= hosts.group(:version).count
      end

      def columns
        query.map { |version, count| [version, count] }
      end

      def search
        query.map do |version, _count|
          [version, hosts_path(search: "omaha_group = #{omaha_group} and omaha_version = #{version}")]
        end.to_h
      end
    end
  end
end
