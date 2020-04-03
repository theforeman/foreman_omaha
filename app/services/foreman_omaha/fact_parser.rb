# frozen_string_literal: true

module ForemanOmaha
  class FactParser < ::FactParser
    def operatingsystem
      args = { :name => os_name, :major => facts['osmajor'], :minor => facts['osminor'] }
      description = "#{os_name} #{facts['version']}"
      Coreos.where(args).first ||
        create_coreos_version(args.merge(:description => description,
                                         :release_name => facts['track']))
    end

    def architecture
      name = nil
      name = 'x86_64' if facts['board'] == 'amd64-usr'
      name = 'arm64' if facts['board'] == 'arm64-usr'
      Architecture.where(:name => name).first_or_create unless name.nil?
    end

    def environment; end

    def model; end

    def domain; end

    def ipmi_interface; end

    def certname; end

    def support_interfaces_parsing?
      false
    end

    private

    def os_name
      return 'Flatcar' if facts['distribution']&.downcase == 'flatcar'

      facts['platform']
    end

    def create_coreos_version(attrs)
      previous_version = previous_coreos_version
      return Coreos.create!(attrs) unless previous_coreos_version

      os = previous_version.deep_clone(
        :include => [:ptables, :media, :os_default_templates, :architectures, :provisioning_templates]
      )
      os.update(attrs)
      os
    end

    def previous_coreos_version
      Coreos.where(name: os_name).max_by { |os| Gem::Version.new(os.release) }
    end
  end
end
