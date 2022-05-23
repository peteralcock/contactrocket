class UserController < ApplicationController

	def index
		list
		render('list')
	end

	def list
		if params[:approved] == "false"
			@users = User.where(approved: false)
		else
			@users = User.all
		end
	end

	def logins
		@user = User.find(params[:id])
		@logins = @user.versions.map{|version| version.reify}
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			flash[:notice] = "User Created"
			redirect_to(:action => 'list')
		else
			render('new')
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:notice] = "User Updated"
			redirect_to(:action => 'list')
		else
			render('edit')
		end
	end

	def delete
		@user = User.find(params[:id])
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:notice] = "User Destroyed"
		redirect_to(:action => 'list')
	end

	def global_settings
		@global_settings = GlobalSettings.first
	end

	def update_global_settings
		@global_settings = GlobalSettings.first
		if @global_settings.update_attributes(params[:global_settings])
			flash[:notice] = "Settings Updated"
			redirect_to(:action => 'global_settings')
		else
			render('global_settings')		
		end
	end

	def approve
		@user = User.find(params[:id])
		@user.approved = true
		@user.save
		redirect_to(:action => 'list')
	end

	def revoke
		@user = User.find(params[:id])
		@user.approved = false
		@user.save
		redirect_to(:action => 'list')
	end

end
