class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to dashboard_path(user)
    else
      render :new
    end
  end
end