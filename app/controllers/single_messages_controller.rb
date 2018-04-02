class SingleMessagesController < ApplicationController
  before_action :authenticate_user!
  # before_action :authenticate_admin!

  # create personal chat message
  def create
  	message = SingleMessage.new(message_params)
    message.user = current_user
    if message.save
      flash = nil
      if message.created_at > (message&.room&.single_messages&.last(2)&.first&.created_at + 30.minutes)
        ActionCable.server.broadcast "redirects_#{message.opposite_user(current_user)}", room_id: message.room.id
      elsif message&.room&.single_messages&.count == 1
        ActionCable.server.broadcast "redirects_#{message.opposite_user(current_user)}", room_id: message.room.id
      elsif !message.room.accepted
        flash = "Zineya is busy at the moment" 
      end
      ActionCable.server.broadcast "single_messages_#{current_user.id}", message: render_sender(message), room_id: message.room.id, flash: flash
      ActionCable.server.broadcast "single_messages_#{message.opposite_user(current_user)}", message: render_receiver(message), room_id: message.room.id
      head :ok
    end
  end

  # opens personal chat tab for zineya
  def personal_chats
    @room = Room.find_by(id: params[:id])
    if @room.present? && (@room.user == current_user || (@room.chat_with == current_user.id && @room.accepted))
       @room
    else
      redirect_to root_url  
    end
  end

  # Accepts zineya perosnal chat request
  def accept
    @room = Room.find_by(id: params[:id])
    @room.accepted = true
    @room.save
    redirect_to "/personal_chats/#{@room.id}"
  end

  # Rejects zineya perosnal chat request
  def reject
    @room = Room.find_by(id: params[:id])
    @room.accepted = false
    @room.save
    redirect_to root_url
  end

  private

  def render_sender(message)
    ApplicationController.render(partial: 'single_messages/sender', locals: {message: message })
  end

  def render_receiver(message)
    ApplicationController.render(partial: 'single_messages/receiver', locals: {message: message })
  end
    
  def message_params
    params.require(:single_message).permit(:content, :room_id)
  end
end
