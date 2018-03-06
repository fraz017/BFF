class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user, message, id, type=nil, display=nil)
    ActionCable.server.broadcast('messages', message: render_message(user, message, display), id: id, reply: type, message_id: message.id)
  end

  private

  def render_message(user, message, display)
  	ApplicationController.render(partial: "messages/message", locals: { user: user, :message => message, display: display })
  end
end