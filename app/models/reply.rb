class Reply < ApplicationRecord
  belongs_to :message
  belongs_to :sender, foreign_key: "sender_id", class_name: "User"
end
