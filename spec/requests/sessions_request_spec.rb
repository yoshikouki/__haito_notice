require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  include SessionsHelper

  let(:user) { FactoryBot.create(:user) }
  let(:jill) { FactoryBot.create(:jill) }
  let(:params) do
    {
      session: {
        email: user.email,
        password: user.password,
        remember_me: 0
      }
    }
  end

  describe "#new" do
    it "ログインページは正しく表示されている" do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "#create" do
    it "正しくログインできている" do
      post login_path(params)
      expect(logged_in?).to be true
    end

    it "emailのみ正しくてもログインできない" do
      params[:session][:password] = ''
      post login_path(params)
      expect(response.body).to include "ログインに失敗しました。"
    end
  end

  describe "#destroy" do
    it "正しくログアウトできる" do
      params[:session][:remember_me] = 1
      post login_path(params)
      delete logout_path
      expect(logged_in?).to be false
    end

    it "未ログインの場合にログアウトしても何も起こらない" do
      delete logout_path
      expect(response).to redirect_to root_url
    end
  end
end
