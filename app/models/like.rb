class Like < ApplicationRecord
	belongs_to :user
	belongs_to :message,  optional: true
	belongs_to :reply,  optional: true
	after_save :add_points
	def add_points
		begin
			score = self.reply.sender.messaging_score
			if score.nil?
				score = 10
			else
				score += 10
			end
			self.reply.sender.update_attributes(:messaging_score => score)
		rescue
		end	
	end
end
