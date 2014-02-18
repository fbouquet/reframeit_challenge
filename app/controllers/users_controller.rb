class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index, :edit, :update, :destroy]

  	def show
    	@user = User.find(params[:id])
  	end

	def index
		@users = User.paginate(page: params[:page], per_page: 10)
	end

	def new
	@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
		  sign_in @user
		  flash[:success] = "Welcome, " + @user.first_name + " " + @user.name + "!"
		  redirect_to @user
		else
		  render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params_update)
			flash[:success] = "Successfully changed parameters."
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		@user = User.find(params[:id])
		if @user.destroy
			flash[:success] = "Successfully deleted user."
			redirect_to root_path
		else
			redirect_to @user
		end
	end


	def user_params
    	params.require(:user).permit(:first_name, :name, :email, :influency, :password, :password_confirmation)
  	end

  	def user_params_update
    	params.require(:user).permit(:influency, :password, :password_confirmation)
  	end

  	def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
end	