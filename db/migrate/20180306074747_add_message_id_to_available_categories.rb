class AddMessageIdToAvailableCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :available_categories, :message_id, :integer
  end
end
