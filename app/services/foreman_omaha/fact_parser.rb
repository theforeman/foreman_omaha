module ForemanOmaha
  class FactParser < ::FactParser
    def operatingsystem
      args = { :name => facts['platform'], :major => facts['osmajor'], :minor => facts['osminor'] }
      description = "#{facts['platform']} #{facts['version']}"
      Operatingsystem.where(args).first ||
        Operatingsystem.create!(args.merge(:description => description,
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
  end
end
