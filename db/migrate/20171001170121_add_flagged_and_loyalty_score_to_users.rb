class AddFlaggedAndLoyaltyScoreToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :flagged, :integer
    add_column :users, :loyalty_score, :integer
  end
end
