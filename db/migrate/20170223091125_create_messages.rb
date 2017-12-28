class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :sender_id

      t.timestamps
    end
  end
end
