# frozen_string_literal: true

default_groups = %w[Alpha Beta Stable]

default_groups.each do |group|
  g = ForemanOmaha::OmahaGroup.where(:uuid => group.downcase, :name => group).first_or_create
  raise "Unable to create built in Omaha group: #{format_errors g}" if g.nil? || g.errors.any?
end
