module ForemanOmaha
  class OmahaReport < ::Report
    enum :status => OmahaFacet::VALID_OMAHA_STATUSES

    scoped_search :on => :omaha_version, :rename => :version, :complete_value => true
    scoped_search :on => :status, :complete_value => statuses

    def self.import(report, proxy_id = nil)
      OmahaReportImporter.import(report, proxy_id)
    end

    def self.report_status_column
      'status'
    end

    def self.humanize_class_name
      N_('Omaha Report')
    end

    delegate :to_label, :to_description, :to => :status_mapper

    def operatingsystem
      return if omaha_version.blank?
      args = { :type => 'Coreos', :major => osmajor, :minor => osminor }
      Operatingsystem.find_by(args)
    end

    def osmajor
      omaha_version.gsub(/^(\d+)\.\d\.\d$/, '\1')
    rescue StandardError
      nil
    end

    def osminor
      omaha_version.gsub(/^\d+\.(\d\.\d)$/, '\1')
    rescue StandardError
      nil
    end

    private

    def status_mapper
      StatusMapper.new(status)
    end
  end
end
