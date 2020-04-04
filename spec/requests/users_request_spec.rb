require 'rails_helper'

RSpec.describe "Users", type: :request do
  include SessionsHelper

  let(:user) { FactoryBot.create(:user) }
  let(:jill) { FactoryBot.create(:jill) }

  xdescribe "ログイン済みの場合" do
    before do
      params = { session: { email: user.email } }
      post login_path(params)
    end

    context "不正なユーザー" do
      it "#edit" do
        get edit_user_path(jill)
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "未ログインの場合" do
    it "#new" do
      get signup_path
      expect(response).to have_http_status(:ok)
    end

    it '#mypage' do
      get mypage_path
      expect(response).to redirect_to login_url
    end

    it '#edit' do
      get edit_user_path(user)
      expect(response).to redirect_to login_url
    end

    it '#update' do
      patch user_path(user), params: { user: { name: user.name, email: user.email } }
      expect(response).to redirect_to login_url
    end
  end
end
