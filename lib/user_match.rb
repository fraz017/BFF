require 'fuzzy_match'
class UserMatch
  def initialize(user_id)
    @user_id = user_id
  end

  def perform
  	user = User.find_by(:id => @user_id)
  	if user.city.present? && user.matchers.count < 100
  		users = User.where(:city => user.city)
  		fuzzy_edu = FuzzyMatch.new(users, :read => :education).find_all(user.education)
  		fuzzy_location = FuzzyMatch.new(users, :read => :location).find_all(user.location)
  		result = fuzzy_location & fuzzy_edu
  		if result.present?
  			result.each do |r|
  				if user.matchers.blank? || ( user.matchers.present? && !user.matchers.include?(r) )
  					add = user.matchers.new
  					add.user = user
  					add.matched_with = r.id
            score = 80
            if user.age_range.present? && user.age_range.include?(r.age_range)
              score += 10
            end
            add.profile_score = score
  					add.save!
  				end
  			end
  		end
  	end
  end
end