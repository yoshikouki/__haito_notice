class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # ログイン機能
  include SessionsHelper

  # 許可するparameterをdeviseに通す
  before_action :configure_permitted_parameters, 
                if: :devise_controller?

  # 全てのアクションでロケールを読み込む
  around_action :switch_locale
  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  # url_for関係メソッドでロケールを設定するよう上書き
  def default_url_options
    return {} if params[:locale].blank?

    { locale: I18n.locale }
  end

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

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys:[:name])
      devise_parameter_sanitizer.permit(:account_update, keys:[:name])
    end
end
