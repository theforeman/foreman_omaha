module Api
  module V2
    class OmahaReportsController < V2::BaseController
      include Api::Version2
      include Foreman::Controller::SmartProxyAuth

      before_action :find_resource, :only => [:show, :destroy]
      before_action :setup_search_options, :only => [:index, :last]

      add_smart_proxy_filters :create,
                              :features => proc { ::ForemanOmaha::OmahaReportImporter.authorized_smart_proxy_features }

      def_param_group :omaha_report do
        param :report, Hash, :required => true, :action_aware => true do
          param :host, String, :required => true, :desc => N_('Hostname or certname')
          param :status, ::ForemanOmaha::OmahaReport.statuses.keys,
                :required => true,
                :desc => N_('Omaha update status')
          param :omaha_version, String, :required => true, :desc => N_('Omaha OS version using semantic versioning, e.g. 1590.0.0')
          param :machineid, String, :required => true, :desc => N_('Unique machine id of the host')
          param :omaha_group, String, :required => true, :desc => N_('The uuid if the channel that the host is attached to. Use alpha, beta or stable for built-in channels.')
          param :oem, String, :desc => N_('OEM identifier')
        end
      end

      api :GET, '/omaha_reports/', N_('List all omaha reports')
      param_group :search_and_pagination, ::Api::V2::BaseController

      def index
        @omaha_reports = resource_scope_for_index.my_reports
        @total = resource_scope_for_index.my_reports.count
      end

      api :GET, '/omaha_reports/:id/', N_('Show a omaha report')
      param :id, :identifier, :required => true

      def show; end

      api :POST, '/omaha_reports', N_('Create a omaha report')
      param_group :omaha_report, :as => :create

      def create
        @omaha_report = resource_class.import(params[:omaha_report], detected_proxy.try(:id))
        process_response @omaha_report.errors.empty?
      rescue ::Foreman::Exception => e
        render_message(e.to_s, :status => :unprocessable_entity)
      end

      api :DELETE, '/omaha_reports/:id/', N_('Delete a omaha report')
      param :id, String, :required => true

      def destroy
        process_response @omaha_report.destroy
      end

      api :GET, '/hosts/:host_id/omaha_reports/last', N_('Show the last report for a host')
      param :host_id, String, :required => true, :desc => N_('ID of host')
      param :id, :identifier, :required => true

      def last
        conditions = params[:host_id].present? ? { :host_id => resource_finder(Host.authorized(:view_hosts), params[:host_id]).try(:id) } : nil
        max_id = resource_scope.where(conditions).maximum(:id)
        @omaha_report = resource_scope.find(max_id)
        render :show
      end

      private

      def resource_class
        ::ForemanOmaha::OmahaReport
      end

      def resource_scope(options = {})
        super(options.merge(:permission => :view_omaha_reports)).my_reports
      end

      def action_permission
        case params[:action]
        when 'last'
          'view'
        else
          super
        end
      end
    end
  end
end
