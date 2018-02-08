class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_admin, except: [:post_reply]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if resource.admin? || resource.manager?
      admin_dashboard_path
    else
      Delayed::Job.enqueue MatchUsersJob.new(current_user.id)
      root_url
    end    
  end

  private
  def check_admin
  	if user_signed_in? && (current_user.role == :admin || current_user.role == :manager)
			admin_dashboard_path
		else
			return true
		end
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name, :location, :education, :gender, :coordinates, :city, :area, :state, :country, :country_code, :date_of_birth, :college ])
  end
end
