require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:jill) { FactoryBot.create(:jill) }

  describe "#edit" do
    it "reset_digestが発行されている" do
      expect { user.create_reset_digest }.to \
        change { user.reset_digest.nil? }.from(true).to(false)
    end

    it "不正なユーザーはアクセスできない" do
      user.create_reset_digest
      get edit_password_reset_url(user.reset_token, email: user.email)
    end

    it "有効期限が切れたユーザーはアクセスできない"
  end
end
