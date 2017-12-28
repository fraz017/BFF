class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    if !current_user.admin?
      current_user.is_online = 1
      current_user.save
      ActionCable.server.broadcast('status', id: current_user.id, online: true)
    end
  end
 
  def unsubscribed
    if !current_user.admin?
      current_user.is_online = 0
      current_user.save
      ActionCable.server.broadcast('status', id: current_user.id, online: false)
    end  
  end
end