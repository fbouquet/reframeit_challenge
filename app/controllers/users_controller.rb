class UsersController < ApplicationController
  	def show
    	@user = User.find(params[:id])
  	end

	def index
		@users = User.all
	end

	def new
	@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
		  sign_in @user
		  flash[:success] = "Successfully signed up."
		  redirect_to @user
		else
		  render 'new'
		end
	end

	def user_params
    	params.require(:user).permit(:first_name, :name, :email, :influency, :password, :password_confirmation)
  	end
end