class CreateReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :replies do |t|
      t.references :message, foreign_key: true, on_delete: :cascade
      t.text :content
      t.integer :sender_id

      t.timestamps
    end
  end
end
