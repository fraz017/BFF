class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user, id)
    ActionCable.server.broadcast('messages', message: render_message(user), id: id)
  end

  private

  def render_message(user)
  	ApplicationController.render(partial: 'messages/new_messages', locals: { user: user })
  end
end