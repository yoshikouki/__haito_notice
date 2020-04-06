require 'rails_helper'

RSpec.describe "Watchlists", type: :request do
  let!(:user)    { FactoryBot.create(:user) }
  let!(:company) { FactoryBot.create(:company) }
  let!(:watchlists) { user.watchlists }
  let(:user_login_params) do
    {
      session: {
        email: user.email,
        password: user.password,
        remember_me: 0
      }
    }
  end
  let(:params) do
    { user_id: user.id, local_code: company.local_code }
  end

  describe "ログインしている場合" do
    before do
      post login_path(user_login_params)
    end

    it '#create' do
      expect { post watch_path(company.local_code, params) }.to \
        change(watchlists, :count).by(1)
    end

    it '#destroy' do
      post watch_path(company.local_code, params)
      expect { delete unwatch_path(company.local_code, params) }.to \
        change(watchlists, :count).by(-1)
    end
  end

  describe "未ログインの場合" do
    it '#create' do
      post watch_path(company.local_code)
      expect(response).to redirect_to login_path
    end

    it '#destroy' do
      post unwatch_path(company.local_code)
      expect(response).to redirect_to login_path
    end
  end
end
