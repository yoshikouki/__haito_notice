class PasswordResetsController < ApplicationController
  # GET /password_resets/new
  def new; end

  # POST /password_resets/
  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.send_reset_email
      flash[:success] = "ご登録メールアドレスにパスワード再設定のURLを送信しました。"
      redirect_to login_path
    else
      flash[:danger] = "不正なメールアドレスです。"
      render 'new'
    end
  end

  # GET /password_reset/:reset_token/edit?email=:email
  def edit
    correct_access(params[:id])
  end

  # POST /password_resets/:id
  def update
    return unless correct_access(params[:reset_token])

    @user.update(user_params)
    if @user.save
      flash[:success] = "パスワードは再設定されました。"
      redirect_to login_path
    else
      flash[:danger] = "不正な入力値です。"
      render :edit
    end
  end

  def correct_access(reset_token)
    @user = User.find_by(email: params[:email])
    if @user&.authenticated?(:reset, reset_token)
      if @user.reset_sent_at.since(1.hour) < Time.zone.now
        flash[:danger] = "パスワード再設定URLの有効期限が切れています。"
        redirect_to login_path
      else
        true
      end
    else
      flash[:danger] = "不正なアクセスです。"
      redirect_to login_path
    end
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end
end
