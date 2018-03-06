class BroadcastAllJob < ApplicationJob
  queue_as :default

  def perform(user, message, id)
    ActionCable.server.broadcast('messages', message: render_message(user, message), id: id)
  end

  private

  def render_message(user, message)
  	ApplicationController.render(partial: 'messages/message', locals: { user: user, message: message })
  end
end