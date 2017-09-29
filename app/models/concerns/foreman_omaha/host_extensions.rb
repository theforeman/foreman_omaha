module ForemanOmaha
  module HostExtensions
    extend ActiveSupport::Concern
    included do
      has_many :omaha_reports, :class_name => '::ForemanOmaha::OmahaReport',
                               :foreign_key => :host_id, :dependent => :destroy
      has_one :last_omaha_report_object, -> { order("#{Report.table_name}.id DESC") },
              :foreign_key => :host_id, :class_name => '::ForemanOmaha::OmahaReport'

      scope :with_coreos_channel, ->(channel) { joins(:operatingsystem).where(:operatingsystems => { :type => 'Coreos', :release_name => channel }) }
      scope :with_coreos_release, ->(channel, version) do
        joins(:operatingsystem).where(
          :operatingsystems => {
            :type => 'Coreos',
            :release_name => channel,
            :major => Gem::Version.new(version).segments.first,
            :minor => Gem::Version.new(version).segments.last(2).join('.')
          }
        )
      end

      scoped_search :relation => :operatingsystem, :on => :type, :complete_value => true, :rename => :os_family, :only_explicit => true
      scoped_search :relation => :operatingsystem, :on => :release_name, :complete_value => true, :rename => :os_release_name, :only_explicit => true
    end
  end
end
