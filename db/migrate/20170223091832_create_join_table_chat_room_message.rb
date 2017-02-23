class CreateJoinTableChatRoomMessage < ActiveRecord::Migration[5.0]
  def change
    create_join_table :chat_rooms, :messages do |t|
      t.integer :chat_room_id
      t.integer :message_id
      t.index [:chat_room_id, :message_id]
      t.index [:message_id, :chat_room_id]
    end
  end
end
