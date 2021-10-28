class AddUserId < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :user_id, :integer
  end
end
