class CreateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :logs do |t|
      t.string :log_type
      t.integer :sender_id
      t.integer :message_id
      t.text :content

      t.timestamps
    end
  end
end
