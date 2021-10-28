class ChangeFinish < ActiveRecord::Migration[6.1]
  def change
    remove_column :wordbooks, :finish, :boolean
    add_column :wordbooks, :finish_number, :integer
  end
end
