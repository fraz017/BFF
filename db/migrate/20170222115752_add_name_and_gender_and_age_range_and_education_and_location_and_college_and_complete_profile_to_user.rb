class AddNameAndGenderAndAgeRangeAndEducationAndLocationAndCollegeAndCompleteProfileToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :gender, :string
    add_column :users, :age_range, :string
    add_column :users, :education, :string
    add_column :users, :location, :string
    add_column :users, :college, :string
    add_column :users, :complete_profile, :boolean, default: false
  end
end
