module HostStatus
  class OmahaStatus < HostStatus::Status
    def last_report
      self.last_report = host.last_omaha_report_object unless @last_report_set
      @last_report
    end

    def last_report=(report)
      @last_report_set = true
      @last_report = report
    end

    def self.status_name
      N_('Omaha Status')
    end

    def to_status(_options = {})
      return ::ForemanOmaha::OmahaReport.statuses[:unknown] unless relevant?
      ::ForemanOmaha::OmahaReport.statuses[last_report.status]
    end

    def to_global(_options = {})
      return ::ForemanOmaha::OmahaReport.statuses[:unknown] unless relevant?
      case last_report.status.to_sym
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
      last_report.to_label
    end

    def relevant?(_options = {})
      host && last_report.present?
    end
  end
end
