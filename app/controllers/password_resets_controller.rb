class PasswordResetsController < ApplicationController
  def new; end

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

  def edit
    @user = User.find_by(email: params[:email])
    if @user &.authenticated?(:reset, params[:id])
      unless @user.reset_sent_at.since(1.hour) > Time.zone.now
        flash[:danger] = "パスワード再設定URLの有効期限が切れています。"
        redirect_to login_path
      end
    else
      flash[:danger] = "不正なアクセスです。"
      redirect_to login_path
    end
  end

  def update
    true
  end
end
