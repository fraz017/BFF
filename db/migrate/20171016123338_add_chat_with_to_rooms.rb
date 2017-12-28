class AddChatWithToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :chat_with, :integer
  end
end
