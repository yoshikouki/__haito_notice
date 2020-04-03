require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "未ログインの場合" do
    it 'マイページへのアクセス' do
      get mypage_path
      expect(response).to redirect_to login_path
    end

    it 'アカウント編集へのアクセス' do
      get edit_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
end
