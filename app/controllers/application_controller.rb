class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # ログイン機能
  include SessionsHelper

  # 許可するparameterをdeviseに通す
  before_action :configure_permitted_parameters, 
                if: :devise_controller?
  before_action :set_var

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

    def set_var
      @bootstrap_class_list = BOOTSTRAP_CLASS_LIST.deep_dup
    end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

  BOOTSTRAP_CLASS_LIST = {
    page_title:           'h4 mb-5',
    link_list:            '',
    link_list_btn:        'btn btn-secondary mb-3',
    link_list_btn_block:  'btn btn-light btn-block mb-3',
    link_list_text:       'small mb-2',
    link_btn_secondary:   'btn btn-secondary mb-3',
    link_btn_block:       'btn btn-primary btn-block mb-5',
    link_btn_block_light: 'btn btn-light btn-block mb-5',
    status_badge:         'badge badge-secondary badge-sm col-4 mr-2',
    job_badge:            'badge badge-light badge-pill',
    new_badge:            'badge badge-primary badge-sm',
    form:                 'my-5',
    form_group:           'form-group mb-3',
    form_field:           'form-control',
    form_submit:          'btn btn-block btn-primary font-weight-bold my-4 py-4',
    form_submit_small:    'btn btn-light font-weight-bold',
    form_small_text:      'form-text small text-gray',
    form_errors:          'mb-5',
    form_errors_title:    'h5',
    form_errors_lists:    'list-group',
    form_errors_list:     'list-group-item list-group-item-dark py-1'
  }.freeze
end
