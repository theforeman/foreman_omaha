module OmahaHostsHelper
  def last_omaha_report_column(record)
    time = record.omaha_facet.last_report? ? _('%s ago') % time_ago_in_words(record.omaha_facet.last_report) : ''
    link_to_if_authorized(time,
                          hash_for_host_omaha_report_path(:host_id => record.to_param, :id => 'last'),
                          last_omaha_report_tooltip(record))
  end

  def last_omaha_report_tooltip(record)
    opts = { :rel => 'twipsy' }
    if @last_report_ids[record.id]
      opts['data-original-title'] = _('View last report details')
    else
      opts.merge!(:disabled => true, :class => 'disabled', :onclick => 'return false')
      opts['data-original-title'] = _('Report Already Deleted') unless record.omaha_facet.last_report.nil?
    end
    opts
  end

  def list_view_class_for_omaha_status(status)
    klasses = [
      iconclass_for_omaha_status(status),
      'list-view-pf-icon-md'
    ]
    klasses << case status.to_sym
               when :complete
                 'list-view-pf-icon-success'
               when :downloading
                 'list-view-pf-icon-info'
               when :downloaded
                 'list-view-pf-icon-success'
               when :installed
                 'fa fa-sign-in text-success'
               when :instance_hold
                 'list-view-pf-icon-warning'
               when :error
                 'list-view-pf-icon-danger'
               else
                 'list-view-pf-icon-info'
               end
    klasses.join(' ')
  end
end
