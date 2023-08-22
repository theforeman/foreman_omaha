# frozen_string_literal: true

module ForemanOmaha
  class OmahaGroup < ApplicationRecord
    include Authorizable

    def self.humanize_class_name
      N_('Omaha Channel')
    end

    graphql_type '::Types::OmahaGroup'

    has_many :omaha_facets, :class_name => 'ForemanOmaha::OmahaFacet', :foreign_key => :omaha_group_id,
                            :inverse_of => :omaha_group, :dependent => :restrict_with_exception
    has_many :hosts, :class_name => '::Host::Managed', :through => :omaha_facets,
                     :inverse_of => :omaha_group

    scoped_search :on => :name, :complete_value => :true, :default_order => true

    validates_lengths_from_database

    before_validation :ensure_uuid

    def operatingsystems
      Coreos.where(:release_name => name.downcase)
    end

    def latest_operatingsystem
      operatingsystems.reorder('').order(:major, :minor).last
    end

    private

    def ensure_uuid
      self.uuid ||= SecureRandom.uuid
    end
  end
end
