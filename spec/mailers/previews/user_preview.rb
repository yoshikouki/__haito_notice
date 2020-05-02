# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def account_activation
    init_user = { name:                  'mailer_test',
                  email:                 'mailer_test@email.com',
                  password:              'password',
                  password_confirmation: 'password' }
    @user = User.create(init_user)
    @user.activation_token = User.new_token
    UserMailer.account_activation(@user)
  end

  def password_reset
    @user = User.first
    @user.create_reset_digest
    UserMailer.password_reset(@user)
  end
end
