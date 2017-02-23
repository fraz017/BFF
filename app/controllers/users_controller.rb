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

  private
  def user_params
    params.require(:user).permit(:location, :education, :gender, :coordinates, :city, :area, :state, :country, :country_code)
  end
end
