class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'messages'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
  	ActionCable.server.broadcast('messages', user: render_message(data['messages']))
  end

  private

  def render_message(user)
    ApplicationController.render(partial: 'messages/new_messages',
                                 locals: { user: user })
  end
end
