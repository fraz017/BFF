class CreateChatRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_rooms do |t|
      t.references :user, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
