module ProxyStatus
  class Omaha < Base
    def self.humanized_name
      'Omaha'
    end

    def tracks
      fetch_proxy_data('/tracks') do
        api.tracks.map(&:deep_symbolize_keys)
      end
    end

    def releases(track, architecture)
      fetch_proxy_data("/tracks/#{track}/#{architecture}") do
        api.releases(track, architecture).map(&:deep_symbolize_keys)
      end
    end

    protected

    def api_class
      ProxyAPI::Omaha
    end
  end
end
