# frozen_string_literal: true

require File.expand_path('lib/foreman_omaha/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'foreman_omaha'
  s.version     = ForemanOmaha::VERSION
  s.authors     = ['Timo Goebel']
  s.email       = ['mail@timogoebel.name']
  s.homepage    = 'http://github.com/theforeman/foreman_omaha'
  s.licenses    = ['GPL-3']
  s.summary     = 'This plug-in adds support for the Omaha procotol to The Foreman.'
  # also update locale/gemspec.rb
  s.description = 'This plug-in adds support for the Omaha procotol to The Foreman. It allows you to better manage and update your CoreOS servers.'

  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'jquery-matchheight-rails'

  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rubocop', '>= 0.80.0'
  s.add_development_dependency 'rubocop-minitest', '~> 0.7.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.5.2'
  s.add_development_dependency 'rubocop-rails', '~> 2.4.2'
end
