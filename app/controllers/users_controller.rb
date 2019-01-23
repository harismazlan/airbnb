class UsersController < ApplicationController
	before_action :set_user, except: [:index]
  	before_action :check_role, only: [:edit, :update, :destroy]
  	before_action :require_login

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
	end

	def destroy
	end

	def edit
	end

	def update
		@user = User.find(params[:id])
		@user.update(user_params)
		redirect_to user_path
	end

	def index
		if !current_user.superadmin? && !signed_in?
			redirect_to "/"
			flash[:error] = "NO"
		else
			@users = User.order(:id).page(params[:page])
			# respond_to do |format|
			# 	format.html {render action: "index"}
			# 	format.js
			# end
		end
	end

private
	def user_params
		params.require(:user).permit(
			:first_name,
			:last_name,
			:email,
			:password,
			:role,
			:avatar
		)
	end

	def set_user
		@user = User.find(params[:id])
	end

	def check_role
		redirect_to root_path if !current_user.superadmin? && current_user != @user
	end
end