module ForemanOmaha
  class VersionBreakdown
    def query
      Report.select(
        [:reported] + version_queries
      ).from(
        Report.select(
          [
            :host_id, Report.arel_table[:omaha_version].maximum.as('version'), reported_at_date_format.as('reported')
          ]
        ).where(
          Report.arel_table[:type].eq('ForemanOmaha::OmahaReport')
        ).group(:reported, :host_id).as('sub')
      ).group(:reported)
    end

    def versions
      @versions ||= ForemanOmaha::OmahaReport.distinct.pluck(:omaha_version)
    end

    def version_queries
      versions.map do |version|
        Arel::Nodes::NamedFunction.new(
          'SUM', [
            Arel.sql(
              "CASE WHEN version = '#{version}' THEN 1 ELSE 0 END"
            )
          ]
        ).as(version_to_sql(version))
      end
    end

    def reported_at_date_format
      case adapter_type
      when :sqlite
        Arel::Nodes::NamedFunction.new('DATE', [Report.arel_table[:reported_at]])
      when :mysql, :mysql2
        Arel::Nodes::NamedFunction.new('DATE_FORMAT', [Report.arel_table[:reported_at], Arel::Nodes.build_quoted('%Y-%m-%d')])
      when :postgresql
        Arel::Nodes::NamedFunction.new(
          'CAST',
          [
            Arel::Nodes::NamedFunction.new(
              'to_date',
              [
                Arel::Nodes::NamedFunction.new(
                  'CAST',
                  [
                    Report.arel_table[:reported_at].as('TEXT')
                  ]
                ),
                Arel::Nodes.build_quoted('YYYY-MM-DD')
              ]
            ).as('TEXT')
          ]
        )
      else
        raise NotImplementedError, "Unknown adapter type '#{adapter_type}'"
      end
    end

    def adapter_type
      ActiveRecord::Base.connection.adapter_name.downcase.to_sym
    end

    def to_a
      query.map do |record|
        versions.each_with_object({}) do |version, hash|
          hash[version.to_sym] = record.attributes[version_to_sql(version)]
        end.merge(
          :date => record.reported
        )
      end.sort_by { |entry| entry[:date].to_date }
    end

    private

    def version_to_sql(version)
      "cnt_#{version.tr('.', '_')}"
    end

    def sub
      Arel::Table.new('sub')
    end
  end
end
