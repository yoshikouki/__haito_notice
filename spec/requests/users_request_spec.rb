require 'rails_helper'

RSpec.describe "Users", type: :request do
  include SessionsHelper

  let(:user) { FactoryBot.create(:user) }
  let(:user_all) { User.all }
  let(:jill) { FactoryBot.create(:jill) }

  describe "ログイン済みの場合" do
    let(:user_login_params) do
      {
        session: {
          email:       user.email,
          password:    user.password,
          remember_me: 0
        }
      }
    end

    before do
      post login_path(user_login_params)
    end

    it "admin属性はWeb上では変更できない" do
      patch user_path(user), params: { user: { admin: true } }
      expect(user.reload.admin).to eq false
    end

    context "不正なユーザー" do
      it "#edit" do
        get edit_user_path(jill)
        expect(response).to redirect_to root_url
      end

      it "#create" do
        patch user_path(jill), params: { user: { name: jill.name + "test" } }
        expect(response).to redirect_to root_url
      end

      it "#delete" do
        # jillを参照して先にletを読み込んでおく
        jill.valid?
        expect { delete user_path(jill) }.not_to change(user_all, :count)
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
