class BlockUnblockUsersJob < Struct.new(:user_id, :type)
  def perform
  	user = User.find_by(:id => user_id)
  	if type == "block"
      user.blocked = true
    else
      user.blocked = false
    end
    user.save
  end

  def max_attempts
    1
  end
end