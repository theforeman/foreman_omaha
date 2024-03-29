# frozen_string_literal: true

require 'jquery-matchheight-rails'

module ForemanOmaha
  class Engine < ::Rails::Engine
    engine_name 'foreman_omaha'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/services"]
    config.autoload_paths += Dir["#{config.root}/app/lib"]

    # Add any db migrations
    initializer 'foreman_omaha.load_app_instance_data' do |app|
      ForemanOmaha::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_omaha.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_omaha do
        requires_foreman '>= 3.0'

        automatic_assets(false)
        precompile_assets(['foreman_omaha/version_breakdown.css', 'foreman_omaha/application.js'])

        apipie_documented_controllers ["#{ForemanOmaha::Engine.root}/app/controllers/api/v2/*.rb"]

        register_custom_status HostStatus::OmahaStatus

        # Add permissions
        security_block :foreman_omaha do
          permission :view_omaha_reports, {
            :omaha_reports => [:index, :show, :auto_complete_search],
            :'api/v2/omaha_reports' => [:index, :show, :last]
          }, :resource_type => 'ForemanOmaha::OmahaReport'

          permission :destroy_omaha_reports, {
            :omaha_reports => [:destroy],
            :'api/v2/omaha_reports' => [:destroy]
          }, :resource_type => 'ForemanOmaha::OmahaReport'

          permission :upload_omaha_reports, {
            :omaha_reports => [:create],
            :'api/v2/omaha_reports' => [:create]
          }, :resource_type => 'ForemanOmaha::OmahaReport'

          permission :view_omaha_groups, {
            :omaha_groups => [:index, :auto_complete_search, :show],
            :'api/v2/omaha_groups' => [:index, :show]
          }, :resource_type => 'ForemanOmaha::OmahaGroup'
        end

        role 'Omaha reports viewer',
             [:view_omaha_reports],
             'Role granting permissions to view Omaha reports.'
        role 'Omaha reports manager',
             [:view_omaha_reports, :destroy_omaha_reports, :upload_omaha_reports],
             'Role granting permissions to manage Omaha reports.'

        # add menu entry
        menu :top_menu, :omaha_reports,
             :url_hash => { controller: :omaha_reports, action: :index },
             :caption => N_('Omaha Reports'),
             :parent => :monitor_menu,
             :after => :reports

        menu :top_menu, :omaha_hosts,
             :url_hash => { :controller => :omaha_hosts, :action => :index },
             :caption => N_('Omaha Hosts'),
             :parent => :hosts_menu,
             :after => :hosts

        divider :top_menu, :caption => N_('Omaha'), :parent => :configure_menu, :last => true

        menu :top_menu, :omaha_groups,
             :url_hash => { :controller => :omaha_groups, :action => :index },
             :caption => N_('Omaha Groups'),
             :parent => :configure_menu,
             :last => :true

        # Omaha Facet
        register_facet(ForemanOmaha::OmahaFacet, :omaha_facet) do
          api_view :list => 'foreman_omaha/api/v2/omaha_facets/base_with_root', :single => 'foreman_omaha/api/v2/omaha_facets/show'
        end

        # extend host show page
        extend_page('hosts/show') do |context|
          context.add_pagelet :main_tabs,
                              :name => N_('Omaha'),
                              :partial => 'hosts/omaha_tab',
                              :onlyif => proc { |host| host.omaha_facet }
        end

        add_controller_action_scope('HostsController', :index) { |base_scope| base_scope.includes(:omaha_facet) }

        # add renderer extensions
        extend_template_helpers ForemanOmaha::TemplateRendererHelper
        allowed_template_helpers :transpile_container_linux_config

        register_graphql_query_field :omaha_group, 'ForemanOmaha::Types::OmahaGroup', :record_field
        register_graphql_query_field :omaha_groups, 'ForemanOmaha::Types::OmahaGroup', :collection_field

        register_graphql_query_field :omaha_report, 'ForemanOmaha::Types::OmahaReport', :record_field
        register_graphql_query_field :omaha_reports, 'ForemanOmaha::Types::OmahaReport', :collection_field
      end

      # Extend built in permissions
      Foreman::AccessControl.permission(:view_hosts).actions.concat [
        'omaha_hosts/index',
        'omaha_hosts/auto_complete_search'
      ]
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      Foreman::Plugin.fact_importer_registry.register(:foreman_omaha, ForemanOmaha::FactImporter, true)

      if Foreman::Plugin.respond_to?(:fact_parser_registry)
        Foreman::Plugin.fact_parser_registry.register(:foreman_omaha, ForemanOmaha::FactParser, true)
      else
        Foreman::Plugin.fact_importer_registry.register(:foreman_omaha, ForemanOmaha::FactParser, true)
      end

      ::Host::Managed.include(ForemanOmaha::HostExtensions)
      ::Host::Managed.include(ForemanOmaha::OmahaFacetHostExtensions)
      ::HostsHelper.include(ForemanOmaha::HostsHelperExtensions)
      ::Types::Host.include(ForemanOmaha::Types::HostExtensions)
    rescue StandardError => e
      Rails.logger.warn "ForemanOmaha: skipping engine hook (#{e})"
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanOmaha::Engine.load_seed
      end
    end

    initializer 'foreman_omaha.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../..', __dir__), 'locale')
      locale_domain = 'foreman_omaha'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
