class BroadcastAllJob < ApplicationJob
  queue_as :default

  def perform(user, id)
    ActionCable.server.broadcast('messages', message: render_message(user), id: id)
  end

  private

  def render_message(user)
  	ApplicationController.render(partial: 'messages/admin_message', locals: { user: user })
  end
end