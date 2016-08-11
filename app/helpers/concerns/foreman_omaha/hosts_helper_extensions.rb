module ForemanOmaha
  module HostsHelperExtensions
    extend ActiveSupport::Concern

    included do
      alias_method_chain :show_appropriate_host_buttons, :foreman_omaha
    end

    def show_appropriate_host_buttons_with_foreman_omaha(host)
      buttons = show_appropriate_host_buttons_without_foreman_omaha(host)
      buttons << (link_to_if_authorized(_('Omaha'), hash_for_host_omaha_reports_path(:host_id => host), :title => _('Browse host omaha reports'), :class => 'btn btn-default') if host.omaha_reports.any?)
      buttons.compact
    end
  end
end
