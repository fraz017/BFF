module ApplicationHelper
	def get_replies(message_id)
		@logs = Log.where(log_type: "reply", message_id: message_id)
		html = ""
		@logs.each do |log|
			html += "<div><span class='reply-text'><strong>#{log.sender.email}:</strong> #{log.content}</span><span class='text-muted pull-right'>#{log.created_at.strftime("%d %b %l:%M %P ")}</span></div></br>" 
		end
		html.html_safe
	end
	def message_reported(message_id, user_id, type = '')
		if type.present?
			message = ReportedMessage.where(:reply_id => message_id, user_id: user_id).last
		else
			message = ReportedMessage.where(:message_id => message_id, user_id: user_id).last
		end	
		if message.present?
			true
		else
			false
		end
	end
end
