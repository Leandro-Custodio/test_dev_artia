class CreateFilterGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :filter_groups do |t|
      t.references :filter_configuration, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
