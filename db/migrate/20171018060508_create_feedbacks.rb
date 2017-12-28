class CreateFeedbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :feedbacks do |t|
      t.references :user, foreign_key: true
      t.string :rating
      t.text :message

      t.timestamps
    end
  end
end
