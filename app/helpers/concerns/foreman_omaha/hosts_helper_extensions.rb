module ForemanOmaha
  module HostsHelperExtensions
    extend ActiveSupport::Concern

    module Overrides
      def show_appropriate_host_buttons(host)
        buttons = super
        if host.omaha_reports.any?
          buttons << link_to_if_authorized(
            _('Omaha'),
            hash_for_host_omaha_reports_path(:host_id => host),
            :title => _('Browse host omaha reports'),
            :class => 'btn btn-default'
          )
        end
        buttons.compact
      end
    end

    included do
      prepend Overrides
    end
  end
end
