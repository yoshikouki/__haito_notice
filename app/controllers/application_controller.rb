class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # ログイン機能
  include SessionsHelper

  private
    # ログアウトしている場合、ログインページにリダイレクト
    def logged_in_user
      unless logged_in?
        flash[:warning] = "ご利用のページはログインが必要です。"
        redirect_to login_url
      end
    end

    # ログインしている場合、マイページにリダイレクト
    def logged_out_user
      if logged_in?
        flash[:info] = "ログアウトしてから再度お試しください。"
        redirect_to mypage_url
      end
    end
end
