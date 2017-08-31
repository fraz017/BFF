require 'fuzzy_match'
class MessagesController < ApplicationController
	before_action :authenticate_user!
	before_action :check_profile, :if => proc {|c| !request.xhr?}

  def index
    @messages = Message.where("content ilike ?", "%#{params[:term]}%")
    @messages = @messages.where("content ilike '%?%'")
    respond_to do |format|
      format.html
      format.js { render json: @messages.map(&:content).uniq.first(5) }
    end
  end

  def post_message
    params.permit!
  	@message = Message.create(content: params[:message], sender_id: current_user.id)
    log = Log.create(content: params[:message], sender_id: current_user.id, log_type: "message", message_id: @message.id)
    current_user.chat_room.messages << @message  
  	MessageBroadcastJob.perform_now(current_user, current_user.chat_room.id)
    LogBroadcastJob.set(wait: 10.seconds).perform_later(log)
    @users = User.where(country_code: current_user.country_code).where.not(id: current_user.id).order("score DESC").limit(20)
  	@users.each do |user|
  		user.chat_room.messages << @message
      MessageBroadcastJob.perform_now(user, user.chat_room.id)
  	end
  end

  def post_reply
    params.permit!
    @message = Message.find(params[:message_id])
    match = FuzzyMatch.new(@message.replies, read: :content).find(params[:reply])
    if match.present?
      match.score += 1
      match.save
    end
    @reply = Reply.create(content: params[:reply], sender_id: current_user.id, message_id: params[:message_id])
    log = Log.create(content: params[:reply], sender_id: current_user.id, message_id: params[:message_id], log_type: "reply")
    MessageBroadcastJob.perform_now(@reply.sender, @reply.sender.chat_room.id)
    LogBroadcastJob.set(wait: 10.seconds).perform_later(log)
    MessageBroadcastJob.set(wait: 2.minutes).perform_later(@message.sender, @message.sender.chat_room.id)
  end

  def save_category
    if params[:message_id].present? && params[:category].present?
      category = Category.new
      category.message_id = params[:message_id]
      category.name = params[:category]
      category.save
      result = true
    else
      result = false  
    end
    render json: { success: true }
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
