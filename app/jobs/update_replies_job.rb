class UpdateRepliesJob < ApplicationJob
  queue_as :default

  def perform(user, message, id, type=nil)
    if message.replies.where(visible: true).count >= 3
      message.update_attributes(:display => true)
    end
    MessageBroadcastJob.perform_now(user, message, id, true, true)
  end
end