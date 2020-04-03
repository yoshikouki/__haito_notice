require 'rails_helper'

RSpec.describe "Watchlists", type: :request do
  let(:user)    { FactoryBot.create(:user) }
  let(:company) { FactoryBot.create(:company) }
  # let(:params)  do
  #   { user_id: user.id, local_code: company.local_code }
  # end

  it 'ログインしていないとウォッチできない' do
    post watch_path(company.local_code)
    expect(response).to redirect_to login_path
  end

  it 'ログインしていないとアンウォッチできない' do
    post unwatch_path(company.local_code)
    expect(response).to redirect_to login_path
  end
end
