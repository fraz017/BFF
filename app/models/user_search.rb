class UserSearch < FortyFacets::FacetSearch
  model 'User' 
  text :email
  facet :education
  facet :age_range, name: 'Age Range'
  facet :location
  facet :city
  facet :gender
  scope :users
end