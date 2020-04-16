# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def password_reset
    @user = User.first
    @user.create_reset_digest
    UserMailer.password_reset(@user)
  end
end
