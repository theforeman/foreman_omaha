module ForemanOmaha
  class FactParser < ::FactParser
    def operatingsystem
      args = { :name => facts['platform'], :major => facts['osmajor'], :minor => facts['osminor'] }
      description = "#{facts['platform']} #{facts['version']}"
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

    def create_coreos_version(attrs)
      previous_version = previous_coreos_version
      return Coreos.create!(attrs) unless previous_coreos_version
      os = previous_version.deep_clone(
        :include => [:ptables, :media, :os_default_templates, :architectures]
      )
      os.update_attributes(attrs)
      os
    end

    def previous_coreos_version
      Coreos.all.sort_by { |os| Gem::Version.new(os.release) }.last
    end
  end
end
