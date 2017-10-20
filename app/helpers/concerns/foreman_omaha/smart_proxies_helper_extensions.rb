module ForemanOmaha
  module SmartProxiesHelperExtensions
    extend ActiveSupport::Concern

    included do
      SmartProxiesHelper::TABBED_FEATURES.push('Omaha')
    end

    def omaha_version_breakdown_chart
      data = ForemanOmaha::VersionBreakdown.new
      chart_data = {}
      data.to_a.each do |entry|
        date = entry.delete(:date)
        date = date.to_date.to_time.to_i * 1000
        entry.each do |version, count|
          chart_data[version] ||= []
          chart_data[version] << [date, count]
        end
      end
      output = []
      data.versions.each do |version|
        output << {
          :label => version,
          :data => chart_data[version.to_sym]
        }
      end
      output
    end

    def omaha_version_breakdown_bar(track, repo_versions = [])
      colors = {
        :success => ['#3f9c35', '#6ec664', '#2d7623'],
        :warning => ['#ec7a08', '#f7bd7f', '#f39d3c'],
        :danger => ['#cc0000', '#a30000', '#8b0000', '#470000']
      }
      versions = current_version_breakdown(track)
      repo_versions = repo_versions.map { |version| Gem::Version.new(version) }.sort.reverse
      current = repo_versions.max
      content_tag :div, :class => 'progress' do
        safe_join(versions.map do |version|
          semver = Gem::Version.new(version[:version])
          position = repo_versions.index(semver)
          css = {
            :width => "#{version[:percentage]}%"
          }
          label = if semver > current
                    :info
                  elsif semver == current
                    :success
                  elsif position == 1
                    :warning
                  else
                    :danger
                  end
          if colors.key?(label)
            color = colors[label].first
            colors[label].rotate!
            css[:'background-color'] = color
          end
          content_tag :div,
                      :class => "progress-bar progress-bar-#{label}",
                      :role => 'progressbar',
                      :style => css_style(css) do
            version[:version]
          end
        end)
      end
    end

    def inline_pie(opts = {})
      percentage = opts.fetch(:percentage, 0)
      fill = '#ededed'
      background = '#292e34'
      container_css = {
        :display => 'inline-flex',
        :'align-self' => 'center',
        :position => 'relative',
        :height => '1em',
        :width => '1em'
      }
      svg_css = {
        :width => '1em',
        :height => '1em',
        :transform => 'rotate(-90deg)',
        :background => fill,
        :'border-radius' => '50%',
        :display => 'inline-block',
        :'vertical-align' => 'middle',
        :bottom => '-0.125em',
        :position => 'absolute'
      }
      circle_css = {
        :fill => fill,
        :stroke => background,
        :'stroke-width' => 32,
        :'stroke-dasharray' => "#{percentage.round} 100"
      }
      content_tag :div, :style => css_style(container_css) do
        content_tag :svg,
                    :viewBox => '0 0 32 32',
                    :style => css_style(svg_css) do
          content_tag :circle, '',
                      :r => '16',
                      :cx => '16',
                      :cy => '16',
                      :style => css_style(circle_css)
        end
      end
    end

    def coreos_hosts_count(track, version)
      current_version_breakdown(track).detect do |release|
        release[:version] == version
      end || {
        :version => version,
        :count => 0,
        :percentage => 0
      }
    end

    def current_version_breakdown(track)
      @current_version_breakdown ||= {}
      @current_version_breakdown[track] ||= ForemanOmaha::CurrentVersionBreakdown.new(:track => track).version_breakdown
    end

    def coreos_hosts_count_link(track, version)
      semver = Gem::Version.new(version)
      major = semver.segments.first
      minor = semver.segments.last(2).join('.')
      count = coreos_hosts_count(track, version)
      link_to_if_authorized(
        safe_join([count[:count], ' ', inline_pie(:percentage => count[:percentage])]),
        hash_for_hosts_path(:search => "os_family = Coreos and os_release_name = #{track} and os_major = #{major} and os_minor = #{minor}")
      )
    end

    def css_style(hash)
      hash.map { |k, v| "#{k}: #{v};" }.join(' ')
    end
  end
end
