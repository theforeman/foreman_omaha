module ForemanOmaha
  class CurrentVersionBreakdown
    attr_accessor :track

    def initialize(opts = {})
      self.track = opts.fetch(:track)
    end

    def version_breakdown
      query.count.transform_keys { |k| k.join('.') }.sort_by { |version, _| Gem::Version.new(version) }.reverse.map do |version, count|
        {
          :version => version,
          :count => count,
          :percentage => percentage(count)
        }
      end
    end

    def all
      @all ||= Host::Managed.with_coreos_channel(track).count
    end

    def query
      Host::Managed.joins(:operatingsystem).where(
        :operatingsystems => {
          :type => 'Coreos',
          :release_name => track
        }
      ).group('operatingsystems.major', 'operatingsystems.minor')
    end

    private

    def percentage(count)
      return 0 if all.zero? || count.zero?
      (count.to_f * 100 / all).round(2)
    end
  end
end
