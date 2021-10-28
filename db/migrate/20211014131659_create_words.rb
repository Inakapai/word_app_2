class CreateWords < ActiveRecord::Migration[6.1]
  def change
    create_table :words do |t|
      t.string :name
      t.string :meaning
      t.string :image_name
      t.integer :user_id
      t.timestamps
    end
  end
end
