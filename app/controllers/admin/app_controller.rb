class Admin::AppController < ApplicationController
	layout "admin"
	# skip_before_action :check_admin
	before_action :admin_restricted

	private
	
	def admin_restricted
		if user_signed_in? && current_user.role == :admin
			return true
		else
			redirect_to root_url
		end
	end	
end