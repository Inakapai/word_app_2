class AddSimilar < ActiveRecord::Migration[6.1]
  def change
    add_column :words, :group_id, :integer
  end
end
