require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }

  describe "#remember (remember_me機能)" do
    before do
      remember user
    end

    it "ログインしている" do
      expect(logged_in?).to be true
    end

    it "current_userは機能している" do
      expect(current_user).to eq user
    end

    it "remember_digestが不正な場合は機能しない" do
      user.update_attribute(
        :remember_digest, User.digest(User.new_token)
      )
      expect(current_user).to be nil
    end
  end
end
