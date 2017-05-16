class OmahaReportsController < ApplicationController
  include Foreman::Controller::AutoCompleteSearch

  before_action :setup_search_options, :only => :index

  def model_of_controller
    ::ForemanOmaha::OmahaReport
  end

  def index
    @omaha_reports = resource_base_search_and_page(:host)
  end

  def show
    # are we searching for the last report?
    if params[:id] == 'last'
      conditions = if params[:host_id].present?
                     {
                       :host_id => resource_finder(Host.authorized(:view_hosts), params[:host_id]).try(:id)
                     }
                   else
                     {}
                   end
      params[:id] = resource_base.where(conditions).maximum(:id)
    end

    return not_found if params[:id].blank?

    @omaha_report = resource_base.includes(:logs => [:message, :source]).find(params[:id])
    @offset = @omaha_report.reported_at - @omaha_report.created_at
  end

  def destroy
    @omaha_report = resource_base.find(params[:id])
    if @omaha_report.destroy
      process_success(
        :success_msg => _('Successfully deleted report.'),
        :success_redirect => omaha_reports_path
      )
    else
      process_error
    end
  end

  # TODO: Remove for Foreman 1.14+
  def resource_base_with_search
    resource_base.search_for(params[:search], :order => params[:order])
  end

  # TODO: Remove for Foreman 1.14+
  def resource_base_search_and_page(tables = [])
    base = tables.empty? ? resource_base_with_search : resource_base_with_search.eager_load(*tables)
    base.paginate(:page => params[:page], :per_page => params[:per_page])
  end

  private

  def resource_base
    super.my_reports
  end
end
