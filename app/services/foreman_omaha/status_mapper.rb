module ForemanOmaha
  class StatusMapper
    attr_accessor :status

    def initialize(status)
      @status = status
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
  end
end
