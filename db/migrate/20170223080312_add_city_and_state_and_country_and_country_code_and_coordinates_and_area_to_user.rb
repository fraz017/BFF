class AddCityAndStateAndCountryAndCountryCodeAndCoordinatesAndAreaToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :country, :string
    add_column :users, :country_code, :string
    add_column :users, :coordinates, :string
    add_column :users, :area, :string
  end
end
