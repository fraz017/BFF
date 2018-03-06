class Admin::DashboardsController < Admin::AppController
	skip_before_action :admin_restricted, only: :profile
  # layout "application", only: [:messages]
	def dashboard
		@search = UserSearch.new(params)
    @users = @search.result.where.not(:role_cd => 0).paginate(page: params[:page], per_page: 5)
	end

	def logs
		@logs = Log.where(log_type: "message").order("created_at desc").last(100)
	end

	def messages
		@messages = Message.order("id desc").first(20)
		@user = current_user
    render layout: "application"
	end

	def change_category
		@message = Message.find(params[:message_id])
		category = AvailableCategory.find_by(name: params[:category])
		@message.available_category = category
		@message.save
		respond_to do |format|
      format.js
    end
	end

	def refresh_messages
		@messages = Message.order("id desc").first(20)
		@user = current_user
		respond_to do |format|
      format.js
    end
	end

	def change_role
		@user = User.find(params[:id])
		if @user.role == :user
			role = :manager
		else
			role = :user	
		end
		@user.update_attributes(:role => role)
		respond_to do |format|
			format.js 
		end
	end

	def import
    AbuseFilter.import(params[:file])
    redirect_to request.referer, notice: "File imported."
  end

  def import_file
  end

	def block_unblock
		user = User.find_by(:id => params[:user_id])
		if user.blocked
			block = false
		else
			block = true
		end	
		user.update_attributes(:blocked => block)
		redirect_to admin_dashboard_path, notice: block ? "Successfully Blocked" : "Successfully Unblocked!"
	end

	def broadcast_message
	end

	def send_message
		@message = Message.create(content: params[:message], sender_id: current_user.id)
		User.all.each do |user|
  		user.chat_room.messages << @message
      BroadcastAllJob.perform_now(user, @message, user.chat_room.id)
  	end
  	redirect_to request.referer
	end

	def reported_messages
		@messages = ReportedMessage.get_messages
	end

	def delete_message
		if params[:id].present?
			msg = Message.find_by_id(params[:id])
			msg.destroy if msg.present?
		end
		redirect_to request.referer, notice: "Successfully Deleted!"
	end

	def profile
		@user = User.find(params[:id])
		respond_to do |format|
			format.js 
		end
	end
end
