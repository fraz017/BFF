class Admin::DashboardsController < Admin::AppController
	skip_before_action :admin_restricted, only: :profile
	def dashboard
		@users = User.all.where(role_cd: 1).paginate(:page => params[:page], :per_page => 10)
		@logs = Log.all.last(100)
	end

	def profile
		@user = User.find(params[:id])
		respond_to do |format|
			format.js 
		end
	end
end
