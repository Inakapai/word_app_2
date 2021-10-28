class Highest < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :correct_number, :integer
    add_column :users, :false_number, :integer
  end
end
