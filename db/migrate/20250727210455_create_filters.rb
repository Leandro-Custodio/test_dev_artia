class CreateFilters < ActiveRecord::Migration[8.0]
  def change
    create_table :filters do |t|
      t.references :filter_group, null: false, foreign_key: true
      t.string :field
      t.string :operator
      t.string :value
      t.integer :position

      t.timestamps
    end
  end
end
