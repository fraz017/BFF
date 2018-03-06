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
			message = ReportedMessage.where(:reply_id => message_id, reported_by: user_id).last
		else
			message = ReportedMessage.where(:message_id => message_id, reported_by: user_id).last
		end
		message
	end
	def liked?(message_id, user_id, type = '')
		if type.present?
			like = Like.where(:reply_id => message_id, user_id: user_id).last
		else
			like = Like.where(:message_id => message_id, user_id: user_id).last	
		end
		like
	end
	def category(name)
		cat = AvailableCategory.find_by(name: name)
	end

  def link_to_toggle_report_message(message, user, type = "")

    if message_reported(message.id, user.id, type)
      link_to('<span class="tick">
                <i class="fa fa-flag"></i>
              </span>'.html_safe, messages_report_path({message_id: message.id, type: type}), 
              method: :post, 
              id: "unreport_message_link_#{message.id}",
              class: "unreport_message action transparent",
              remote: true)
    else
      link_to('<span class="tick">
                <i class="fa fa-flag-o"></i>
              </span>'.html_safe, messages_report_path({message_id: message.id, type: type}), 
              method: :post, 
              id: "report_message_link_#{message.id}", 
              class: "report_message action transparent", 
              remote: true)
    end

  end

  def link_to_toggle_like_message(message, user, type = "")

    if liked?(message.id, user.id, type)
      link_to('<span class="tick">
                <i class="fa fa-thumbs-up"></i>
              </span>'.html_safe, messages_like_path({message_id: message.id, type: type}), 
              method: :post, 
              id: "unlike_message_link_#{message.id}",
              class: "unlike_message action transparent",
              remote: true)
    else
      link_to('<span class="tick">
                <i class="fa fa-thumbs-o-up"></i>
              </span>'.html_safe, messages_like_path({message_id: message.id, type: type}), 
              method: :post, 
              id: "like_message_link_#{message.id}", 
              class: "like_message action transparent", 
              remote: true)
    end

  end

end
