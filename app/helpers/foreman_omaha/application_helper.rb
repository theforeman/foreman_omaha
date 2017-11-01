module ForemanOmaha
  module ApplicationHelper
    def facets_count(association, resource_name = controller.resource_name)
      @facets_count ||= Host::Managed.reorder('').authorized.joins(association).group("#{resource_name}_id").count
    end
  end
end
