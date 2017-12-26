class AddOmahaFieldsToReports < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :omaha_version, :string
  end
end
