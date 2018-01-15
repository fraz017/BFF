class SingleMessageJob < ApplicationJob
  queue_as :default

  def perform(user, room)
    ActionCable.server.broadcast('single_messages', message: render_message(user, room), id: room.id)
  end

  private

  def render_message(user, room)
  	ApplicationController.render(partial: 'single_messages/user_chat', locals: { user: user, room: room })
  end
end