# frozen_string_literal: true

attributes :id, :last_report, :version, :machineid, :status

child :omaha_group => :omaha_group do
  attributes :id, :name
end
