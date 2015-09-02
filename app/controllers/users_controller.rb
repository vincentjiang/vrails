class UsersController < ApplicationController
  before_action :require_admin
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, notice: "注册成功"
    else
      flash.now[:error] = @user.errors.full_messages.join(", ")
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation)
    end
end
