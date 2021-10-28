class Finish < ActiveRecord::Migration[6.1]
  def change
    add_column :wordbooks, :finish_id, :integer
  end
end
