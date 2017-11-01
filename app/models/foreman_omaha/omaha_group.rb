module ForemanOmaha
  class OmahaGroup < ActiveRecord::Base
    include Authorizable

    def self.humanize_class_name
      N_('Omaha Channel')
    end

    has_many :omaha_facets, :class_name => 'ForemanOmaha::OmahaFacet', :foreign_key => :omaha_group_id,
                            :inverse_of => :omaha_group, :dependent => :restrict_with_exception
    has_many :hosts, :class_name => '::Host::Managed', :through => :omaha_facets,
                     :inverse_of => :omaha_group

    scoped_search :on => :name, :complete_value => :true, :default_order => true

    validates_lengths_from_database

    before_validation :ensure_uuid

    private

    def ensure_uuid
      self.uuid ||= SecureRandom.uuid
    end
  end
end
