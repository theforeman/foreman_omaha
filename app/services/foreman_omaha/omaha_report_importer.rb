module ForemanOmaha
  class OmahaReportImporter < ::ReportImporter
    def report_name_class
      OmahaReport
    end

    def self.authorized_smart_proxy_features
      @authorized_smart_proxy_features ||= super + ['Omaha']
    end

    private

    def create_report_and_logs
      super
      @report.omaha_version = omaha_version
      @report.save
      @report
    end

    def report_status
      raw['status']
    end

    def omaha_version
      raw['omaha_version'] || 'unknown'
    end
  end
end
