class CreateAbuseFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :abuse_filters do |t|
      t.string :abuse

      t.timestamps
    end
  end
end
