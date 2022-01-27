class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or root_url
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  def portfolio_new
  end

  def portfolio_create
    user = User.guest
    log_in user
    flash[:success] = 'ゲストユーザーとしてログインしました。'
    redirect_to root_url
  end

  def destroy
  # ログイン中の場合のみログアウト処理を実行します。
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
  
end
