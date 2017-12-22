# Tasks
namespace :foreman_omaha do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanOmaha'
  Rake::TestTask.new(:foreman_omaha) do |t|
    test_dir = File.join(File.dirname(__FILE__), '../..', 'test')
    t.libs << ['test', test_dir]
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_omaha do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_omaha) do |task|
        task.patterns = ["#{ForemanOmaha::Engine.root}/app/**/*.rb",
                         "#{ForemanOmaha::Engine.root}/lib/**/*.rb",
                         "#{ForemanOmaha::Engine.root}/test/**/*.rb"]
      end
    rescue StandardError
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_omaha'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_omaha']

load 'tasks/jenkins.rake'
Rake::Task['jenkins:unit'].enhance ['test:foreman_omaha', 'foreman_omaha:rubocop'] if Rake::Task.task_defined?(:'jenkins:unit')
