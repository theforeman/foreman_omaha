class OmahaGroupsController < ApplicationController
  include Foreman::Controller::AutoCompleteSearch

  before_action :setup_search_options, :only => :index

  def model_of_controller
    ::ForemanOmaha::OmahaGroup
  end

  def index
    @omaha_groups = resource_base_with_search
  end
end
