module ProxyAPI
  class Omaha < ProxyAPI::Resource
    def initialize(args)
      @url = args[:url] + '/omaha'
      super(args)
    end

    def tracks
      parse(get('tracks'))
    end

    def releases(track, architecture)
      parse(get("tracks/#{track}/#{architecture}"))
    end
  end
end
