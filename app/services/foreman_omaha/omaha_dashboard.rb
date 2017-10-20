module ForemanOmaha
  module OmahaDashboard
    def self.hosts
      Host.authorized(:view_hosts, Host).joins(:omaha_reports).distinct
    end
  end
end
