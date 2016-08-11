module OmahaReportsHelper
  def iconclass_for_omaha_status(status)
    case status.to_sym
    when :complete
      'pficon pficon-ok'
    when :downloading
      'fa fa-download text-info'
    when :downloaded
      'fa fa-download text-success'
    when :installed
      'fa fa-sign-in text-success'
    when :instance_hold
      'fa fa-pause-circle-o text-warning'
    when :error
      'pficon pficon-error-circle-o'
    else
      'th'
    end
  end

  def operatingsystem_link(operatingsystem)
    link_to_if_authorized(os_name(operatingsystem),
                          hash_for_edit_operatingsystem_path(
                            :id => operatingsystem
                          ).merge(:auth_object => operatingsystem,
                                  :authorizer => authorizer))
  end
end
