class Admin::DashboardsController < Admin::AppController
	def dashboard
		@users = User.all.where(role_cd: 1).paginate(:page => params[:page], :per_page => 10)
		@logs = Log.all.last(100)
	end
end
