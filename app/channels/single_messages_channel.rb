class SingleMessagesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'single_messages'
  end
end