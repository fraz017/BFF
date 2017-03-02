class Log < ApplicationRecord
	belongs_to :sender, foreign_key: "sender_id", class_name: "User"
end
