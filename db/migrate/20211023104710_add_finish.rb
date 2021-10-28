class AddFinish < ActiveRecord::Migration[6.1]
  def change
    add_column :wordbooks, :finish, :boolean, default: false, null: false
  end
end
