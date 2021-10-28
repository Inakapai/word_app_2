class CreateTagWords < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_words do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :word, null: false, foreign_key: true

      t.timestamps
    end
  end
end
