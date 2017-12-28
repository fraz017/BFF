class AddFlaggedColumn < ActiveRecord::Migration[5.0]
  def change
  	add_column :messages, :flagged, :integer
  	add_column :messages, :visible, :boolean, default: true
  	add_column :replies, :visible, :boolean, default: true
  	add_column :replies, :flagged, :integer
  	add_column :reported_messages, :reported_by, :integer
  	add_column :reported_messages, :reply_id, :integer
  end
end
