class AddBlockedAndAverageScoreToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :blocked, :boolean, default: false
    add_column :users, :average_score, :float
  end
end
