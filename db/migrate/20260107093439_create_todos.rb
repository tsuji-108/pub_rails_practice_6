class CreateTodos < ActiveRecord::Migration[8.1]
  def change
    create_table :todos do |t|
      t.string :name
      t.text :content
      t.string :is_completed

      t.timestamps
    end
  end
end
