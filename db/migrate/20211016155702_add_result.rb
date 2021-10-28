class AddResult < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :result, :string
  end
end
