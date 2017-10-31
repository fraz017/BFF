class UsersController < ApplicationController
	before_action :authenticate_user!

  def profile
  	@user = current_user
  end

  def update
  	@user = User.find(params[:id])
  	@user.complete_profile = true
  	respond_to do |format|
	  	if @user.update(user_params)
	      format.html { redirect_to root_path, notice: 'User was successfully updated.' }
	    else
	      format.html { render :profile }
	    end
	  end
  end

  def refresh_header
    respond_to do |format|
      format.js
    end
  end

  def feedback
    if params[:rating].present? && params[:message].present?
      feed = Feedback.new
      feed.user = current_user
      feed.rating = params[:rating]
      feed.message = params[:message]
      feed.save
      ApplicationMailer.send_feedback(feed).deliver_now
    end
    redirect_to request.referer, notice: "Feedback saved!"
  end

  private
  def user_params
    params.require(:user).permit(:name, :location, :education, :gender, :coordinates, :city, :area, :state, :country, :country_code, :date_of_birth)
  end
end
