module Api
  module V2
    class OmahaGroupsController < V2::BaseController
      include Api::Version2

      before_action :setup_search_options, :only => [:index]

      api :GET, '/omaha_reports/', N_('List all omaha groups')
      param_group :search_and_pagination, ::Api::V2::BaseController

      def index
        @omaha_groups = resource_scope_for_index
        @total = resource_scope_for_index.count
      end

      private

      def resource_class
        ::ForemanOmaha::OmahaGroup
      end
    end
  end
end
