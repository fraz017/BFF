class Message < ApplicationRecord
  has_and_belongs_to_many :chat_rooms
  has_many :replies
end
