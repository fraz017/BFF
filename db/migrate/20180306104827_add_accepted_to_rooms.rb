class AddAcceptedToRooms < ActiveRecord::Migration[5.0]
  def change
    add_column :rooms, :accepted, :boolean, default: false
  end
end
