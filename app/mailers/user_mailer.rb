class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    @url = edit_account_activation_url(user.activation_token, email: user.email)
    mail to: user.email, subject: "配当ノーティスへのご登録をありがとうございます！"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "【配当ノーティス】パスワードの再設定"
  end
end
