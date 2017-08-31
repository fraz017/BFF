require 'obscenity/active_model'
class Message < ApplicationRecord
  has_and_belongs_to_many :chat_rooms
  has_many :replies
  has_one :category
  belongs_to :sender, foreign_key: "sender_id", class_name: "User"
  validates :content,  obscenity: { sanitize: true, replacement: "[censored]" }
end
