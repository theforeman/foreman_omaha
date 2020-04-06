# frozen_string_literal: true

f = Feature.where(:name => 'Omaha').first_or_create
raise "Unable to create proxy feature: #{format_errors f}" if f.nil? || f.errors.any?
