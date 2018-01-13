class SingleMessagesController < ApplicationController
  def create
  	message = SingleMessage.new(message_params)
    message.user = current_user
    if message.save
      ActionCable.server.broadcast 'single_messages', message: message.content, user: message.user.name, room_id: message.room.id
      head :ok
    end
  end

  def personal_chats
    @rooms = Room.where(:user_id => current_user.id).order("id desc")
    @joined_rooms = Room.where(:chat_with => current_user.id).order("id desc")
  end
  private
 
    def message_params
      params.require(:single_message).permit(:content, :room_id)
    end
end
