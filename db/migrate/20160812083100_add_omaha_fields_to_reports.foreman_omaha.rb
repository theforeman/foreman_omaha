class AddOmahaFieldsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :omaha_version, :string
  end
end
