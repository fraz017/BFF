class Message < ApplicationRecord
  has_and_belongs_to_many :chat_rooms
  has_many :replies
  belongs_to :sender, foreign_key: "sender_id", class_name: "User"
end
