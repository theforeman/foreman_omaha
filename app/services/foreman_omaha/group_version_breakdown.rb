module ForemanOmaha
  class GroupVersionBreakdown
    attr_accessor :omaha_group

    def initialize(opts = {})
      self.omaha_group = opts.fetch(:omaha_group)
    end

    def version_breakdown
      facets.group(:version).count.sort_by { |version, _| Gem::Version.new(version) }.reverse.map do |version, count|
        {
          :version => version,
          :count => count,
          :percentage => percentage(count)
        }
      end
    end

    def facets
      ForemanOmaha::OmahaFacet.where(:omaha_group => omaha_group)
    end

    private

    def percentage(count)
      return 0 if count.zero? || facets.count.zero?

      (count.to_f * 100 / facets.count).round(2)
    end
  end
end
