class RoomsController < ApplicationController
  def new
    if request.referrer.split("/").last == "chatrooms"
      flash[:notice] = nil
    end
    @room = Room.new
  end

  # Create personal chat room
  def create
    @room = Room.find_or_create_by(room_params)
    @room.user = current_user
    msg = Reply.find_by(id: params[:message_id])
    @room.chat_with = msg.sender.id
    msg.sender.add_messaging_score(30)
    @user = msg.sender
    @room.save
  end

  # Create personal chat room with admin
  def admin_create
    @room = Room.find_or_create_by(room_params)
    @room.user = current_user
    if params[:user_id].present?
      @user = User.find_by(id: params[:user_id])
      @room.chat_with = @user.id
    else
      msg = Message.find_by(id: params[:message_id])
      @room.chat_with = msg.sender.id
      msg.sender.add_messaging_score(30)
      @user = msg.sender
    end
    @room.save
    respond_to do |format|
      format.js { render "rooms/create.js.erb" }
    end
  end

  def index
    @room = Room.new
    @rooms = Room.all
  end

  def show
    @room = Room.find_by(name: params[:name])
    @message = SingleMessage.new
  end

  private

  def room_params
    params.require(:room).permit(:title)
  end
end
