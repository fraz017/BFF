class SingleMessage < ApplicationRecord
  belongs_to :user
  belongs_to :room

  def opposite_user(user)
    if room.chat_with == user.id
      room.user.id
    else
      room.chat_with
    end 
  end
end
