class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_admin

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      root_url
    end    
  end

  private
  def check_admin
  	if user_signed_in? && current_user.role == :admin
			redirect_to admin_dashboard_path
		else
			return true
		end
  end
end
