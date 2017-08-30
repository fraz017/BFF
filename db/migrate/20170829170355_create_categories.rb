class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.belongs_to :message
      t.timestamps
    end
  end
end
