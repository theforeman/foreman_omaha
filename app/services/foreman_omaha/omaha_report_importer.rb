module ForemanOmaha
  class OmahaReportImporter < ::ReportImporter
    def report_name_class
      OmahaReport
    end

    def self.authorized_smart_proxy_features
      @authorized_smart_proxy_features ||= super + ['Omaha']
    end

    private

    def host
      @host ||= ForemanOmaha::OmahaFacet.find_by(:machineid => machineid).try(:host) if machineid.present?
      @name ||= @host.try(:name)
      @host || super
    end

    def create_report_and_logs
      super
      return report unless report.persisted?
      report.omaha_version = omaha_version
      report.save
      update_omaha_facet!
      report
    end

    def omaha_facet
      host.omaha_facet || host.build_omaha_facet
    end

    def update_omaha_facet!
      return unless omaha_facet.last_report.nil? || omaha_facet.last_report.utc < time
      omaha_facet.update(
        :last_report => time,
        :status => report_status,
        :machineid => machineid,
        :oem => oem,
        :version => omaha_version,
        :omaha_group => omaha_group
      )
    end

    def report_status
      raw['status']
    end

    def machineid
      raw['machineid']
    end

    def oem
      raw['oem']
    end

    def omaha_version
      raw['omaha_version'] || 'unknown'
    end

    def omaha_group
      ForemanOmaha::OmahaGroup.find_by(:uuid => raw['omaha_group']) || find_omaha_group_by_version
    end

    # If the Report does not contain information
    # about the Omaha Group, we try to find
    # the correct group by looking at the defined
    # operating systems
    def find_omaha_group_by_version
      version = Gem::Version.new(omaha_version)
      major = version.segments.first
      minor = version.segments.last(2).join('.')
      os = Coreos.find_by(:major => major, :minor => minor)
      return unless os
      ForemanOmaha::OmahaGroup.find_by(:uuid => os.release_name)
    end
  end
end
