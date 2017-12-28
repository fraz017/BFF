class CreateAvailableCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :available_categories do |t|
      t.string :name
      t.string :color
      t.string :icon

      t.timestamps
    end
  end
end
