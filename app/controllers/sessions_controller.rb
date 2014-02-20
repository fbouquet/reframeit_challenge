class SessionsController < ApplicationController
  def new
    if signed_in?
      redirect_to current_user
    end    
  end

  def create
    user = User.find_by(email: params[:session][:email])
    unless user.nil?
      user = user.authenticate(params[:session][:password])
      if user.blank?
        flash.now[:error] = "Invalid email or password. Please try again."
        render 'new'
      else
        sign_in user
        redirect_back_or user
      end
    else
      flash.now[:error] = "Invalid email or password. Please try again."
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
