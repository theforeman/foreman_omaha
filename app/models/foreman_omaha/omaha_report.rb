module ForemanOmaha
  class OmahaReport < ::Report
    enum :status => [:unknown, :complete, :downloading, :downloaded,
                     :installed, :instance_hold, :error]

    scoped_search :on => :omaha_version, :rename => :version, :complete_value => true
    scoped_search :on => :status, :complete_value => statuses

    def self.import(report, proxy_id = nil)
      OmahaReportImporter.import(report, proxy_id)
    end

    def self.report_status_column
      'status'
    end

    def to_label
      case status.to_sym
      when :complete
        _('Complete')
      when :downloading
        _('Downloading')
      when :downloaded
        _('Downloaded')
      when :installed
        _('Installed')
      when :instance_hold
        _('Instance Hold')
      when :error
        _('Error')
      else
        _('unknown')
      end
    end

    def operatingsystem
      return if omaha_version.blank?
      args = { :type => 'Coreos', :major => osmajor, :minor => osminor }
      Operatingsystem.find_by(args)
    end

    def osmajor
      omaha_version.gsub(/^(\d+)\.\d\.\d$/, '\1')
    rescue
      nil
    end

    def osminor
      omaha_version.gsub(/^\d+\.(\d\.\d)$/, '\1')
    rescue
      nil
    end
  end
end
