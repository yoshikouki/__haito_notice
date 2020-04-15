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
  end

  def update
  end
end
