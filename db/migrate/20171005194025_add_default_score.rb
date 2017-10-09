class AddDefaultScore < ActiveRecord::Migration[5.0]
  def change
  	change_column :users, :messaging_score, :integer, default: 0
  	change_column :users, :loyalty_score, :integer, default: 0
  end
end
