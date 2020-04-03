require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe "セッション確認" do
    let(:user) { FactoryBot.create(:user) }

    before do
      remember user
    end

    it "ログインした場合、current_userは正しく設定されている" do
      expect(user).to eq current_user
    end

    it "ログインできているか確認できる" do
      expect(logged_in?).to be true
    end

    it "remember_digestが不正な場合、remember_meも機能せずログインしない" do
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to be nil
    end
  end
end
