class CreateLikes < ActiveRecord::Migration[5.0]
  def change
    create_table :likes do |t|
    	t.belongs_to :user
    	t.belongs_to :message
    	t.belongs_to :reply
      t.timestamps
    end
  end
end
