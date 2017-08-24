class LogBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
  	if message.log_type == "message"
  		ActionCable.server.broadcast('logs', message: render_message_logs(message), id: message.id, log_type: 'message')
  	else
  		log = Log.where(:message_id => message.message_id, log_type: "message").first
    	ActionCable.server.broadcast('logs', message: render_reply_logs(message), id: log.id, log_type: 'reply')
    end
  end

  private

  def render_message_logs(message)
  	ApplicationController.render(partial: 'admin/dashboards/new_message', locals: { message: message })
  end
  def render_reply_logs(message)
  	ApplicationController.render(partial: 'admin/dashboards/log_message', locals: { message: message })
  end
end