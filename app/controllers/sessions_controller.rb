class SessionsController < ApplicationController
  before_action :logged_out_user,  only: [:new, :create]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        # ログイン後にユーザー情報のページにリダイレクトする
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      else
        flash[:warning] = "アカウントが有効化されていません。<br>有効化メールをご確認いただき、アカウントを有効化してください"
      end
      redirect_back_or root_url
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'ログインに失敗しました。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
