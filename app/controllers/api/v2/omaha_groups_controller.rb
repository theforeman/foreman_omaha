module Api
  module V2
    class OmahaGroupsController < V2::BaseController
      include Api::Version2

      before_action :find_resource, :only => [:show]
      before_action :setup_search_options, :only => [:index]

      api :GET, '/omaha_groups/', N_('List all omaha groups')
      param_group :search_and_pagination, ::Api::V2::BaseController

      def index
        @omaha_groups = resource_scope_for_index
        @total = resource_scope_for_index.count
      end

      api :GET, '/omaha_groups/:id/', N_('Show a Omaha Group')
      param :id, :identifier, :required => true, :desc => N_('Id of the Omaha Group')

      def show; end

      private

      def resource_class
        ::ForemanOmaha::OmahaGroup
      end
    end
  end
end
