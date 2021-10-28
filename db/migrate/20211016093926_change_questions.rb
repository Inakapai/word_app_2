class ChangeQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :name, :string
    add_column :questions, :option1, :string
    add_column :questions, :option2, :string
    add_column :questions, :option3, :string
  end
end
