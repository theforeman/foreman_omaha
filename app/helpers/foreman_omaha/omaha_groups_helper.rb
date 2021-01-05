# frozen_string_literal: true

module ForemanOmaha
  module OmahaGroupsHelper
    def omaha_version_breakdown_bar(omaha_group)
      stylesheet 'foreman_omaha/version_breakdown'
      colors = {
        :success => ['#3f9c35', '#6ec664', '#2d7623'],
        :warning => ['#ec7a08', '#f7bd7f', '#f39d3c'],
        :danger => ['#cc0000', '#a30000', '#8b0000', '#470000']
      }
      versions = ForemanOmaha::GroupVersionBreakdown.new(:omaha_group => omaha_group).version_breakdown
      version_list = omaha_group.operatingsystems.pluck(:major, :minor).map { |v| Gem::Version.new(v.join('.')) }.sort.reverse
      current = version_list.max
      content_tag :div, :class => 'progress version-breakdown' do
        safe_join(versions.compact.map do |version|
          semver = Gem::Version.new(version[:version])
          position = version_list.index(semver)
          css = {
            :width => "#{version[:percentage]}%"
          }
          label = if !current || semver > current
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
                      :title => version[:version],
                      :style => css_style(css) do
            link_to(
              version[:version],
              hosts_path(:search => "omaha_group = #{omaha_group} and omaha_version = #{version[:version]}")
            )
          end
        end)
      end
    end

    def css_style(hash)
      hash.map { |k, v| "#{k}: #{v};" }.join(' ')
    end
  end
end
