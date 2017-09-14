class ReportedMessage < ApplicationRecord
	def self.get_messages
		hash = ReportedMessage.group(:message_id).count
		result = []
		hash.each do |k, v|
			if v >= 2
				msg = Message.find_by_id k
				result.push(msg)
			end
		end
		result.compact
	end
end
