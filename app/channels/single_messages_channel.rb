class SingleMessagesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from "single_messages_#{current_user.id}"
  end
end