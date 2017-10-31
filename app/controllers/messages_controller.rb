require 'fuzzy_match'
class MessagesController < ApplicationController
	before_action :authenticate_user!
	before_action :check_profile, :if => proc {|c| !request.xhr?}

  def index
    @messages = Message.where("content ilike ? and visible = ?", "%#{params[:term]}%", true)
    @messages = @messages.where("content ilike '%?%'")
    @rooms = Room.where(:user_id => current_user.id)
    @joined_rooms = Room.where(:chat_with => current_user.id)
    respond_to do |format|
      format.html
      format.js { render json: @messages.map(&:content).uniq.first(5) }
    end
  end

  def post_message
    params.permit!
  	@message = Message.create(content: params[:message], sender_id: current_user.id)
    @message.sender.add_loyalty_score(10) if !@message.content.include?("*")
    category = Category.create(message_id: @message.id, name: params[:category])
    log = Log.create(content: params[:message], sender_id: current_user.id, log_type: "message", message_id: @message.id)
    current_user.chat_room.messages << @message  
  	MessageBroadcastJob.perform_now(current_user, current_user.chat_room.id)
    LogBroadcastJob.set(wait: 10.seconds).perform_later(log)
    if current_user.matchers.present?
      current_user.matchers.order(:profile_score).first(10).each do |u|
        user = User.find_by(:id => u.matched_with)
        if user.chat_room.messages.where("created_at >= ?", DateTime.now - 5.minutes).blank? && (user.gender == current_user.gender)
          user.chat_room.messages << @message
          MessageBroadcastJob.perform_now(user, user.chat_room.id)
        end
      end
    else
      @users = User.where(country_code: current_user.country_code).where.not(id: current_user.id).order("score DESC").limit(20)
      @users.each do |user|
        if user.chat_room.messages.where("created_at >= ?", DateTime.now - 5.minutes).blank? && (user.gender == current_user.gender)
          user.chat_room.messages << @message
          MessageBroadcastJob.perform_now(user, user.chat_room.id)
        end
      end
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
    @reply.sender.add_loyalty_score(20) if !@reply.content.include?("*")
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

  def report
    if params[:message_id].present?
      message = Message.find_by_id params[:message_id] if params[:type].nil?
      message = Reply.find_by_id params[:message_id] if params[:type].present?
      if params[:type].present?
        message.sender.minus_messaging_score(20)
      end
      report = ReportedMessage.new
      report.message_id = params[:message_id] if params[:type].nil?
      report.reply_id = params[:message_id] if params[:type].present?
      report.reported_by = current_user.id
      report.user_id = message.sender.id
      report.save
      message.sender.minus_loyalty_score(20)
      message.sender.add_flag_point
      message.add_flag_point
    end
    render json: { success: true }
  end

  def like
    if params[:message_id].present?
      message = Message.find_by_id params[:message_id] if params[:type].nil?
      message = Reply.find_by_id params[:message_id] if params[:type].present?
      if params[:type].present?
        message.sender.add_messaging_score(50)
      end
      like = Like.new
      like.user_id = current_user.id
      like.message_id = params[:message_id] if params[:type].nil?
      like.reply_id = params[:message_id] if params[:type].present?
      like.save
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
