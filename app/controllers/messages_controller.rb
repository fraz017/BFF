class MessagesController < ApplicationController
	before_action :authenticate_user!
	before_action :check_profile, :if => proc {|c| !request.xhr?}

  def index
  end

  def post_message
    params.permit!
  	@message = Message.create(content: params[:message], sender_id: current_user.id)
    current_user.chat_room.messages << @message  
  	MessageBroadcastJob.perform_now(current_user, current_user.chat_room.id)
    @users = User.where(country_code: current_user.country_code).where.not(id: current_user.id)
  	@users.each do |user|
  		user.chat_room.messages << @message
      MessageBroadcastJob.perform_now(user, user.chat_room.id)
  	end

    # ActionCable.server.broadcast 'messages',
    #     user: @users
    #   head :ok
    # respond_to do |format|
    #   format.js
    # end
  end

  private
  def check_profile
  	if user_signed_in? && current_user.complete_profile == false
  		redirect_to profile_path
  	else
  		return true
  	end 
  end
end
