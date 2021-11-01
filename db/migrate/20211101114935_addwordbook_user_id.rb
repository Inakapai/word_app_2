class AddwordbookUserId < ActiveRecord::Migration[6.1]
  def change
    addcolumn :wordbooks, :user_id, :integer 
  end
end
