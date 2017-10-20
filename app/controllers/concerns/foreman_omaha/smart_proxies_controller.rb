module ForemanOmaha
  module SmartProxiesController
    def self.prepended(base)
      base.class_eval do
        alias_method :find_resource_with_omaha, :find_resource
        before_action :find_resource_with_omaha, :only => [:omaha_dashboard, :omaha_releases]
      end
    end

    def omaha_dashboard
      render :partial => 'smart_proxies/plugins/omaha_dashboard'
    rescue Foreman::Exception => exception
      process_ajax_error exception
    end

    def omaha_releases
      @tracks = @smart_proxy.statuses[:omaha].tracks.map do |track|
        track.update(
          :architectures => track[:architectures].map do |architecture|
            releases = @smart_proxy.statuses[:omaha].releases(track[:name], architecture)
            current_release = releases.detect { |release| release[:current] }
            {
              :name => architecture,
              :releases => releases,
              :current_release => current_release
            }
          end,
          :host_count => Host::Managed.with_coreos_channel(track[:name]).count
        )
      end
      render :partial => 'smart_proxies/plugins/omaha_releases'
    rescue Foreman::Exception => exception
      process_ajax_error exception
    end

    private

    def action_permission
      case params[:action]
      when 'omaha_dashboard', 'omaha_releases'
        :view
      else
        super
      end
    end
  end
end
