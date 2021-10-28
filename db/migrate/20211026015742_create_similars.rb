class CreateSimilars < ActiveRecord::Migration[6.1]
  def change
    create_table :similars do |t|
      t.string :name
      t.integer :word_id
      t.timestamps
    end
  end
end
