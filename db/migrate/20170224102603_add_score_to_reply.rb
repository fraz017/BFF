class AddScoreToReply < ActiveRecord::Migration[5.0]
  def change
    add_column :replies, :score, :integer, default: 0
  end
end
