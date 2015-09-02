class SessionsController < ApplicationController
  skip_before_action :require_login
  def new
  end

  def create
    user = User.find_by(email: params[:user][:email])
    if user
      unless user.activation?
        flash.now[:error] = "此邮箱还没有被激活，请激活后再尝试登录"
        render :new and return
      end
      if user.authenticate(params[:user][:password])
        session[:user_id] = user.id
        user.update_last_login_time
        redirect_to (params[:form].present? ? params[:from] : root_path), notice: "登录成功"
      else
        flash.now[:error] = @user_session.errors.full_messages.join(", ")
        render :new
      end
    else
      flash.now[:error] = "邮箱或密码错误，请重试"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to referer, notice: "退出成功"
  end

end
