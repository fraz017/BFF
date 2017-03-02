class LogBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast('logs', message: render_logs(message))
  end

  private

  def render_logs(message)
  	ApplicationController.render(partial: 'admin/dashboards/log_message', locals: { message: message })
  end
end