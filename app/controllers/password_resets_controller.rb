class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:create, :edit, :update]
  before_action :valid_user, only: [:edit, :update]

  # GET /password_resets/new
  def new; end

  # POST /password_resets/
  def create
    if @user
      @user.send_reset_email
      flash[:success] = "ご登録メールアドレスにパスワード再設定のURLを送信しました。"
      redirect_to login_url
    else
      flash[:danger] = "不正なメールアドレスです。"
      render 'new'
    end
  end

  # GET /password_reset/:reset_token/edit?email=:email
  def edit; end

  # POST /password_resets/:id
  def update
    if @user.update(user_params)
      flash[:success] = "パスワードは再設定されました。"
      redirect_to login_url
    else
      flash[:danger] = "不正な入力値です。"
      render :edit
    end
  end

  private

  # before_action #create #edit #update
  def set_user
    @user = User.find_by(email: params[:email].downcase)
  end

  # before_action #edit #update
  def valid_user
    if @user&.authenticated?(:reset, params[:id])
      if @user.reset_sent_at < 1.hour .ago
        flash[:danger] = "パスワード再設定URLの有効期限が切れています。"
        redirect_to new_password_reset_url
      end
    else
      flash[:danger] = "不正なアクセスです。"
      redirect_to login_url
    end
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end
end
