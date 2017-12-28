require 'user_match'
class MatchUsersJob < Struct.new(:user_id) 
  def perform
  	UserMatch.new(user_id).perform
  end

  def max_attempts
    1
  end
end