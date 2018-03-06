class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'messages'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
  	ActionCable.server.broadcast('messages', message: render_message(data.user), id: data.id)
  end

  private

  def render_message(user)
    ApplicationController.render(partial: 'messages/new_messages',locals: { user: user })
  end
end
