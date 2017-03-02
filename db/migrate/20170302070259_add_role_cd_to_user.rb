class AddRoleCdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role_cd, :integer, default: 1
  end
end
