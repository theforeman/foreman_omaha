module ForemanOmaha
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      has_many :omaha_reports, :class_name => '::ForemanOmaha::OmahaReport',
                               :foreign_key => :host_id, :dependent => :destroy,
                               :inverse_of => :host
      has_one :last_omaha_report_object, -> { order("#{Report.table_name}.id DESC") },
              :foreign_key => :host_id, :class_name => '::ForemanOmaha::OmahaReport',
              :inverse_of => :host

      before_save :clear_omaha_facet_on_build
    end

    def clear_omaha_facet
      omaha_facet.destroy if omaha_facet
    end

    def clear_omaha_facet_on_build
      return unless respond_to?(:old) && old && build? && !old.build?

      clear_omaha_facet
    end
  end
end
