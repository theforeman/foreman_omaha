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
        requires_foreman '>= 1.12'

        apipie_documented_controllers ["#{ForemanOmaha::Engine.root}/app/controllers/api/v2/*.rb"]

        register_custom_status HostStatus::OmahaStatus

        # Add permissions
        security_block :foreman_omaha do
          permission :view_omaha_reports, :omaha_reports => [:index, :show, :auto_complete_search],
                                          :'api/v2/omaha_reports' => [:index, :show, :last]
          permission :destroy_omaha_reports, :omaha_reports => [:destroy],
                                             :'api/v2/omaha_reports' => [:destroy]
          permission :upload_omaha_reports, :omaha_reports => [:create],
                                            :'api/v2/omaha_reports' => [:create]
          permission :view_smart_proxies, :smart_proxies => [:omaha_dashboard, :omaha_releases]
        end

        role 'Omaha reports viewer',
             [:view_omaha_reports]
        role 'Omaha reports manager',
             [:view_omaha_reports, :destroy_omaha_reports, :upload_omaha_reports]

        # add menu entry
        menu :top_menu, :omaha_reports,
             :url_hash => { controller: :omaha_reports, action: :index },
             :caption => N_('Omaha reports'),
             :parent => :monitor_menu,
             after: :reports
      end

      if respond_to?(:add_controller_action_scope)
        add_controller_action_scope(HostsController, :index) { |base_scope| base_scope.includes(:last_omaha_report_object) }
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        ::FactImporter.register_fact_importer(:foreman_omaha, ForemanOmaha::FactImporter)
        ::FactParser.register_fact_parser(:foreman_omaha, ForemanOmaha::FactParser)

        Host::Managed.send(:include, ForemanOmaha::HostExtensions)
        HostsHelper.send(:include, ForemanOmaha::HostsHelperExtensions)
        SmartProxiesHelper.send(:include, ForemanOmaha::SmartProxiesHelperExtensions)
        ::SmartProxiesController.send(:prepend, ForemanOmaha::SmartProxiesController)

        ProxyStatus.status_registry.add(ProxyStatus::Omaha)
      rescue => e
        Rails.logger.warn "ForemanOmaha: skipping engine hook (#{e})"
      end
    end

    initializer 'foreman_omaha.assets.precompile' do |app|
      app.config.assets.precompile += %w[foreman_omaha/Omaha.png]
    end

    initializer 'foreman_omaha.configure_assets', :group => :assets do
      SETTINGS[:foreman_omaha] = {
        :assets => {
          :precompile => ['foreman_omaha/Omaha.png']
        }
      }
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanOmaha::Engine.load_seed
      end
    end

    initializer 'foreman_omaha.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_omaha'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
