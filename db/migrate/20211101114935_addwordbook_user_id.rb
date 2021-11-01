class AddwordbookUserId < ActiveRecord::Migration[6.1]
  def change
    add_column :wordbooks, :user_id, :integer 
    add_column :wordbooks, :correct_number, :integer
  end
end
