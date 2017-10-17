class CreateSingleMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :single_messages do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
