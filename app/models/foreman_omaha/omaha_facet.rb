module ForemanOmaha
  class OmahaFacet < ApplicationRecord
    include Facets::Base

    VALID_OMAHA_STATUSES = [:unknown, :complete, :downloading, :downloaded,
                            :installed, :instance_hold, :error].freeze

    enum :status => VALID_OMAHA_STATUSES

    belongs_to :omaha_group, :inverse_of => :omaha_facets, :class_name => 'ForemanOmaha::OmahaGroup'

    validates_lengths_from_database

    validates :omaha_group, :presence => true, :allow_blank => false
    validates :host, :presence => true, :allow_blank => false
    validates :version, format: { with: /\A[0-9]+\.[0-9]+\.[0-9]+\z/, message: _('must use semantic versioning') }

    def to_status_label
      status_mapper.to_label
    end

    def major
      return unless version
      version.split('.').first
    end

    def minor
      return unless version
      version.split('.').last(2).join('.')
    end

    private

    def status_mapper
      StatusMapper.new(status)
    end
  end
end
