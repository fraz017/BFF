class ChatRoom < ApplicationRecord
  belongs_to :user, optional: true
  has_and_belongs_to_many :messages
  # after_create_commit { MessageBroadcastJob.perform_later(self) }
end
