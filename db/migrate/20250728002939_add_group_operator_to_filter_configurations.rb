class AddGroupOperatorToFilterConfigurations < ActiveRecord::Migration[8.0]
  def change
    add_column :filter_configurations, :group_operator, :string
  end
end
