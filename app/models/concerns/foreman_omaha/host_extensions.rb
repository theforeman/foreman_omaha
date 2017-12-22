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
    end
  end
end
