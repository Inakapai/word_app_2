class RemoveGroupId < ActiveRecord::Migration[6.1]
  def change
    remove_column :words, :group_id, :integer
  end
end
