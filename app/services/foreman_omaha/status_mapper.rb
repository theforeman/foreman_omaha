# frozen_string_literal: true

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

    def to_description(version = nil)
      case status.to_sym
      when :complete
        if version.present?
          _('The host has been updated successfully and is now running version %s.') % version
        else
          _('The host has been updated successfully.')
        end
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
  end
end
