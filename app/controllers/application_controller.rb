class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper
  include GroundsHelper
  include LandingsHelper
  include AccountsHelper

  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforフィルター

  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end
  
  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
  
  def uncorrect_user
    redirect_to(root_url) if current_user?(@user)
  end
  
  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  def accounting_user
    redirect_to root_url unless current_user.accounting?
  end
  
  def admin_and_accounting_user
    redirect_to root_url unless current_user.accounting? || current_user.admin?
  end
  
  # 管理者は許可しない
  def invalid_admin_user
    redirect_to root_url if current_user.admin?
  end
  
  # 管理者または、アクセスしたユーザーが現在ログインしているユーザーだった場合許可
  def admin_or_correct_user
    redirect_to(root_url) unless current_user.admin? || current_user?(@user)
  end
  
  def set_one_month
    @first_day = params[:accounting_date].nil? ? Date.current.beginning_of_month : params[:accounting_date].to_date
    @last_day = @first_day.end_of_month
    @one_month = [*@first_day..@last_day]
    @this_month = @first_day.all_month
  end
  
  
  
end
