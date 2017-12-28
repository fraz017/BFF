class AddMessagingScoreToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :messaging_score, :integer
  end
end
