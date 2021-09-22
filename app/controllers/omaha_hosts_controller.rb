# frozen_string_literal: true

class OmahaHostsController < ApplicationController
  include Foreman::Controller::AutoCompleteSearch
  include ScopesPerAction

  before_action :setup_search_options, :only => :index

  add_scope_for(:index) do |base_scope|
    base_scope.includes(:operatingsystem).includes(:omaha_facet).includes(:omaha_facet => :omaha_group)
  end

  def index
    @hosts = action_scope_for(:index, resource_base_with_search)
    @last_report_ids = ForemanOmaha::OmahaReport.where(:host_id => @hosts.map(&:id)).group(:host_id).maximum(:id)
  end

  def welcome
    has_entries = begin
      resource_base.first.nil?
    rescue StandardError
      false
    end
    if has_entries
      @welcome = true
      render :welcome
    end
  rescue StandardError
    not_found
  end

  protected

  def model_of_controller
    ::Host::Managed
  end

  def resource_base
    super.joins(:omaha_facet)
  end

  def controller_permission
    'hosts'
  end
end
