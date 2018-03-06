class AddDisplayToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :display, :boolean, default: false
  end
end
