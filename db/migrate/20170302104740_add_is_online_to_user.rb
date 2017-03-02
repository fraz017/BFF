class AddIsOnlineToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_online, :boolean, default: false
  end
end
