module HostStatus
  class OmahaStatus < HostStatus::Status
    def self.status_name
      N_('Omaha Status')
    end

    def to_status(_options = {})
      return ::ForemanOmaha::OmahaFacet.statuses[:unknown] unless relevant?
      ::ForemanOmaha::OmahaFacet.statuses[host.omaha_facet.status]
    end

    def to_global(_options = {})
      return ::ForemanOmaha::OmahaFacet.statuses[:unknown] unless relevant?
      case host.omaha_facet.status.to_sym
      when :complete, :downloaded, :downloading, :installed
        HostStatus::Global::OK
      when :instance_hold
        HostStatus::Global::WARN
      when :error
        HostStatus::Global::ERROR
      else
        HostStatus::Global::OK
      end
    end

    def to_label(_options = {})
      host.omaha_facet.to_status_label
    end

    def relevant?(_options = {})
      host && !!host.omaha_facet
    end
  end
end
