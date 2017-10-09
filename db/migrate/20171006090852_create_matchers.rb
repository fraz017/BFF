class CreateMatchers < ActiveRecord::Migration[5.0]
  def change
    create_table :matchers do |t|
    	t.belongs_to :user
    	t.integer :matched_with
    	t.float :profile_score 
      t.timestamps
    end
  end
end
