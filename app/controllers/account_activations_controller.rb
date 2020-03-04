class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "正常にアカウントが有効化されました！ 配当ノーティスをお楽しみください"
      redirect_to user
    else
      flash[:danger] = "エラーが発生しました。お手数ですがもう一度お手続きください。"
      redirect_to root_url
    end
  end
end
