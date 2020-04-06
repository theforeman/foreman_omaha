# frozen_string_literal: true

class OmahaGroupsController < ApplicationController
  include Foreman::Controller::AutoCompleteSearch

  before_action :setup_search_options, :only => :index
  before_action :find_resource, :only => :show

  def index
    @omaha_groups = resource_base_with_search
  end

  def show
    @out_of_sync = ForemanOmaha::OmahaFacet.where(:omaha_group => @omaha_group).out_of_sync.includes(:host)
    @latest_operatingsystem = @omaha_group.latest_operatingsystem
    @status_distribution = ForemanOmaha::Charts::StatusDistribution.new(@omaha_group.hosts)
    @version_distribution = ForemanOmaha::Charts::VersionDistribution.new(@omaha_group.hosts)
    @oem_distribution = ForemanOmaha::Charts::OemDistribution.new(@omaha_group.hosts)
  end

  def model_of_controller
    ::ForemanOmaha::OmahaGroup
  end

  def resource_class
    ::ForemanOmaha::OmahaGroup
  end
end
