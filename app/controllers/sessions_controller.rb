class SessionsController < ApplicationController
  skip_before_action :require_login
  def new
  end

  def create
    result = User.login_confirm(params[:user][:email], params[:user][:password])
    if result[:user_id]
      session[:user_id] = result[:user_id]
      redirect_to root_path, notice: "登录成功"
    else
      flash.now[:error] = result[:error]
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to referer, notice: "退出成功"
  end

end
