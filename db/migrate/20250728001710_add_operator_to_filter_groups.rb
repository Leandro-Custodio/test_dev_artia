class AddOperatorToFilterGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :filter_groups, :operator, :string
  end
end
