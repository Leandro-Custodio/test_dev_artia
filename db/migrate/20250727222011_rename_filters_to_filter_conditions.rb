class RenameFiltersToFilterConditions < ActiveRecord::Migration[8.0]
  def change
    rename_table :filters, :filter_conditions
  end
end
