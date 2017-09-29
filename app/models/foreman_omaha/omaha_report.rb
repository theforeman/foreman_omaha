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

    def self.to_label(status)
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
        _('Unknown')
      end
    end

    def self.to_description(status, version)
      case status.to_sym
      when :complete
        _('The host has been updated successfully and is now running version %s.') % version
      when :downloading
        _('The host has just started downloading the update package.')
      when :downloaded
        _('The host has downloaded the update package and will install it now.')
      when :installed
        _('The host has installed the update package but is not using it yet.')
      when :instance_hold
        _('An update for this host is pending but it was put on hold because of the rollout policy.')
      when :error
        _('The host reported an error while updating.')
      else
        _('The status of this host is unknown.')
      end
    end

    def to_description
      self.class.to_description(status, omaha_version)
    end

    def to_label
      self.class.to_label(status)
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
