module ForemanOmaha
  class StatusMapper
    attr_accessor :status

    def initialize(status)
      @status = status
    end

    def to_label
      case status.to_sym
      when :complete
        N_('Complete')
      when :downloading
        N_('Downloading')
      when :downloaded
        N_('Downloaded')
      when :installed
        N_('Installed')
      when :instance_hold
        N_('Instance Hold')
      when :error
        N_('Error')
      else
        N_('unknown')
      end
    end
  end
end
