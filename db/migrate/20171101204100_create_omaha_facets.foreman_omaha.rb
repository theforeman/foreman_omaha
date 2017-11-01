class CreateOmahaFacets < ActiveRecord::Migration
  def change
    create_table :omaha_groups do |t|
      t.string :name, limit: 255, null: false, index: true
      t.string :uuid, limit: 36, null: false, index: true

      t.timestamps null: false
    end

    create_table :omaha_facets do |t|
      t.references :host, null: false, foreign_key: true, index: true, unique: true
      t.column :last_report, :datetime
      t.string :version, limit: 255, index: true
      t.string :machineid, limit: 32, index: true
      t.integer :status, default: 1, index: true
      t.string :oem, limit: 255, index: true
      t.references :omaha_group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
