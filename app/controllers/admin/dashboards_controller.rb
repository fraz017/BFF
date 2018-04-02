class Admin::DashboardsController < Admin::AppController
  skip_before_action :admin_restricted, only: :profile
  # layout "application", only: [:messages]

  # lists users
  def dashboard
    @search = UserSearch.new(params)
    @users = @search.result.where.not(:role_cd => 0).paginate(page: params[:page], per_page: 25)
  end

  # messages logs
  def logs
    @logs = Log.where(log_type: "message").order("created_at desc").last(100)
  end

  # messages view where admin can reply
  def messages
    @messages = Message.order("id desc").first(20)
    @user = current_user
    render layout: "application"
  end

  # add / change message category
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

  # change user role
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

  # import abuse filter file
  def import
    AbuseFilter.import(params[:file])
    redirect_to request.referer, notice: "File imported."
  end

  def import_file
  end

  # block / unblock users
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

  # broadcast message to zineya users
  def send_message
    @message = Message.create(content: params[:message], sender_id: current_user.id)
    User.all.each do |user|
      user.chat_room.messages << @message
      BroadcastAllJob.perform_now(user, @message, user.chat_room.id)
    end
    redirect_to request.referer
  end

  # view reported messages
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
