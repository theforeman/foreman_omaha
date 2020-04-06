# frozen_string_literal: true

module ForemanOmaha
  module OmahaFacetHostExtensions
    extend ActiveSupport::Concern

    included do
      has_one :omaha_facet, :class_name => '::ForemanOmaha::OmahaFacet', :foreign_key => :host_id, :inverse_of => :host, :dependent => :destroy
      has_one :omaha_group, :through => :omaha_facet, :inverse_of => :hosts

      accepts_nested_attributes_for :omaha_facet, :update_only => true, :reject_if => ->(attrs) { attrs.values.compact.empty? }

      scoped_search :on => :last_report, :relation => :omaha_facet, :rename => :last_omaha_report, :complete_value => true, :only_explicit => true
      scoped_search :on => :machineid, :relation => :omaha_facet, :rename => :omaha_machineid, :complete_value => true, :only_explicit => true
      scoped_search :on => :version, :relation => :omaha_facet, :rename => :omaha_version, :complete_value => true, :only_explicit => true
      scoped_search :on => :oem, :relation => :omaha_facet, :rename => :omaha_oem, :complete_value => true, :only_explicit => true
      scoped_search :on => :status, :relation => :omaha_facet, :rename => :omaha_status, :only_explicit => true, :complete_value => {
        :unknown => 0, :complete => 1, :downloading => 2, :downloaded => 3,
        :installed => 4, :instance_hold => 5, :error => 6
      }

      scoped_search :on => :name, :relation => :omaha_group, :complete_value => true, :rename => :omaha_group, :only_explicit => true
    end
  end
end
