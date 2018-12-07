module ForemanOmaha
  module Charts
    class Base
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

      attr_reader :omaha_group
      delegate :hosts, to: :omaha_group
      delegate :hosts_path, to: 'Rails.application.routes.url_helpers'

      def search
        raise NotImplementedError
      end

      def columns
        raise NotImplementedError
      end
    end
  end
end
