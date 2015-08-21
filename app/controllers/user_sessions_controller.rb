class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params)
    if @user_session.save
      redirect_to root_path, notice: "登录成功"
    else
      flash.now[:error] = @user_session.errors.full_messages.join(", ")
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to root_path, notice: "退出成功"
  end

  private

    def user_session_params
      params.require(:user_session).permit(:email, :password, :remember_me)
    end
  
end
