require 'fuzzy_match'
class MessagesController < ApplicationController
	before_action :check_admin, except: [:post_reply]
  before_action :authenticate_user!
	before_action :check_profile, :if => proc {|c| !request.xhr?}

  def index
    @messages = Message.where("content ilike ? and visible = ?", "%#{params[:term]}%", true)
    @messages = @messages.where("content ilike '%?%'")
    respond_to do |format|
      format.html
      format.js { render json: @messages.map(&:content).uniq.first(5) }
    end
  end

  def post_message
    params.permit!
  	@message = Message.create(content: params[:message], sender_id: current_user.id)
    @message.sender.add_loyalty_score(10) if !@message.content.include?("*")
    log = Log.create(content: params[:message], sender_id: current_user.id, log_type: "message", message_id: @message.id)
    current_user.chat_room.messages << @message  
  	MessageBroadcastJob.perform_now(current_user, @message, current_user.chat_room.id)
    LogBroadcastJob.set(wait: 10.seconds).perform_later(log)
    UpdateRepliesJob.set(wait: 60.minutes).perform_later(current_user, @message, current_user.chat_room.id, true)
    if current_user.matchers.present? && current_user.matchers.count >= 10
      current_user.matchers.order(:profile_score).first(10).each do |u|
        user = User.find_by(:id => u.matched_with)
        if user != current_user && user.chat_room.messages.where("created_at >= ?", DateTime.now - 5.minutes).blank? && (user.gender == current_user.gender)
          user.chat_room.messages << @message
          MessageBroadcastJob.perform_now(user, @message, user.chat_room.id)
        end
      end
    else
      @users = User.where(country_code: current_user.country_code).where.not(id: current_user.id).order("score DESC").limit(20)
      @users.each do |user|
        if user != current_user && user.chat_room.messages.where("created_at >= ?", DateTime.now - 5.minutes).blank? && (user.gender == current_user.gender)
          user.chat_room.messages << @message
          MessageBroadcastJob.perform_now(user, @message, user.chat_room.id)
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
    MessageBroadcastJob.perform_now(@reply.sender, @message, @reply.sender.chat_room.id, true)
    LogBroadcastJob.set(wait: 10.seconds).perform_later(log)
    MessageBroadcastJob.perform_now(@message.sender, @message, @message.sender.chat_room.id, true)
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
      @reported = true
      message = Message.find_by_id params[:message_id] if params[:type].blank?
      message = Reply.find_by_id params[:message_id] if params[:type].present?
      report = ReportedMessage.where("message_id = ? or reply_id = ?", message.id, message.id).last
      if report.present?
        report.destroy
        @reported = false
        if params[:type].present?
          message.sender.add_messaging_score(20)
        end
        message.sender.add_loyalty_score(20)
        message.sender.minus_flag_point
        message.minus_flag_point
      else  
        report = ReportedMessage.new
        report.message_id = params[:message_id] if params[:type].blank?
        report.reply_id = params[:message_id] if params[:type].present?
        report.reported_by = current_user.id
        report.user_id = message.sender.id
        report.save
        if params[:type].present?
          message.sender.minus_messaging_score(20)
        end
        message.sender.minus_loyalty_score(20)
        message.sender.add_flag_point
        message.add_flag_point
      end  
    end
    @type = params[:type]
    @message = message
    @user = current_user
    respond_to do |format|
      format.js
    end
  end

  def like
    if params[:message_id].present?
      message = Message.find_by_id params[:message_id] if params[:type].blank?
      message = Reply.find_by_id params[:message_id] if params[:type].present?
      like = Like.where("message_id = ? or reply_id = ?", message.id, message.id).last
      @liked = true
      if like.present?
        like.destroy
        @liked = false
        if params[:type].present?
          message.sender.minus_messaging_score(50)
        end
      else
        like = Like.new
        like.user_id = current_user.id
        like.message_id = params[:message_id] if params[:type].blank?
        like.reply_id = params[:message_id] if params[:type].present?
        like.save
        if params[:type].present?
          message.sender.add_messaging_score(50)
        end
      end
    end
    @type = params[:type]
    @message = message
    @user = current_user
    respond_to do |format|
      format.js
    end
  end

  private
  def check_profile
  	if user_signed_in? && current_user.complete_profile == false
  		redirect_to profile_path
  	else
  		return true
  	end 
  end
  def check_admin
    if user_signed_in? && (current_user.role == :admin || current_user.role == :manager)
      redirect_to admin_dashboard_path
    else
      return true
    end
  end
end
